library(shiny)
library(shinydashboard)
library(highcharter)
library(dplyr)
library(tidyr)
library(rdrop2)
library(lubridate)
library(RCurl)
library(plotly)

function(input, output, session) {
  output$downloadCsv <- downloadHandler(
    filename = "arrsets.csv",
    content = function(file) {
      write.csv(datafinal, file)
    },
    contentType = "text/csv"
  )
  output$DownloadCsv <- downloadHandler(
    filename = "arrsetees.csv",
    content = function(file) {
      write.csv(datafinal1, file)
    },
    contentType = "text/csv"
  )
  
  output$arrests <- renderPrint({
    orig <- options(width = 1000)
    print((tail(datafinal, input$maxrows)),row.names=FALSE)
    options(orig)
  })
  output$arrestees <- renderPrint({
    orig <- options(width = 1000)
    print((tail(datafinal1, input$maxrows1)),row.names=FALSE)
    options(orig)
  })
  output$plot1 <- renderHighchart({
    white <- subset(data1, select=c(white, date))
    black <- subset(data1, select=c(black, date))
    hispanic <- subset(data1, select=c(hispanic, date))
    asian <- subset(data1, select=c(asian, date))
    other <- subset(data1, select=c(other, date))
    highchart() %>% 
      hc_chart(type="column") %>% 
      hc_plotOptions(column = list(
        dataLabels = list(enabled = FALSE),
        stacking = "present",
        enableMouseTracking = FALSE)
      ) %>%
      hc_xAxis(categories = unique(as.Date(white$date, "%Y-%m-%d")),
               tickmarkPlacement = 'on') %>% 
      hc_yAxis(title = list(text = "Persons")) %>% 
      hc_add_series(data=white$white, name = "White Population", color="dodgerblue") %>%
      hc_add_series(data=black$black, name = "Black Population", color = "orange") %>%
      hc_add_series(data=hispanic$hispanic, name = "Hispanic/Latino Population", color="green") %>%
      hc_add_series(data=asian$asian, name = "Asian Population", color = "red") %>%
      hc_add_series(data=other$other, name = "Other", color="gray") %>%
      hc_add_theme(hc_theme_gridlight())
  })
  output$table1 <- renderTable({
    lval <- dim(change.data)[1]
    lval <- lval * -1
    change.data.display <- change.data[order(-1:lval),] 
    change.data.display <- head(change.data.display, 11)
  }, digits = 1, include.rownames=FALSE)
  
  output$table2 <- renderTable({
    change.data2
  }, digits = 1, include.rownames=FALSE)
  
  output$pie1 <-renderPlotly({
    plot_ly(change.data, labels = change.data$Race, values = change.data$`Number of population`, type = 'pie') %>%
      layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$pie2 <-renderPlotly({
    plot_ly(change.data1, labels = change.data1$Race, values = change.data1$`Numbers of Total Arrests`, type = 'pie') %>%
    layout(
      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  ###############################chuck new#######################
  output$pie21 <-renderPlotly({ 
    plot_ly(change.data4, labels = change.data4$Jurisdiction, values = change.data4$`Number of arrests`, type = 'pie') %>%
      layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$table21 <- renderTable({
    change.data4
  }, digits = 1, include.rownames=FALSE)
  ###############################################################
  output$plot <- renderHighchart({
    highchart() %>% 
      hc_chart(type="bar") %>% 
      hc_plotOptions(bar = list(
        dataLabels = list(enabled = FALSE),
        stacking = "normal",
        enableMouseTracking = TRUE)
      ) %>%
      hc_xAxis(categories = agem6$Age) %>% 
      hc_yAxis(title = list(text = "Detained")) %>% 
      hc_xAxis(title = list(text = "Age")) %>% 
      hc_add_series(data=agem6$White, name = "White", color="orange") %>%
      hc_add_series(data=agem6$Black, name = "Black", color = "dodgerblue") %>%
      hc_add_series(data=agem6$Hispanics, name = "Hispanic", color="green") %>%
      hc_add_series(data=agem6$Asian, name = "Asian", color = "yellow") %>%
      hc_add_series(data=agem6$Native.American, name = "Native American", color="brown") %>%
      hc_add_series(data=agem6$Unknown, name = "Unknown", color = "Black") %>%
      hc_add_theme(hc_theme_gridlight())
  })
  output$table3 <-renderTable({
    change.data.display3 <- freq18 
    change.data.display3 <- head(change.data.display3, 11)
  }, digits = 1, include.rownames=FALSE)
  
  output$pie3 <-renderPlotly({
    plot_ly(change.data3, labels = change.data3$Race, values = change.data3$`Percentage for arrestees under 18`, type = 'pie') %>%
      layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  ###############################################################
  output$plotyuyan1 <- renderHighchart({
    # choices <-as.character(unique(arrestdata$CRIME_CODE_CATEGORY_DESCRIPTION))
    # choices <- c(choices,"All Crime Types")
    # if (input$crimecategory == "All Crime Types"){
    #   selectdata <- arrestdata
    # }
    if (input$crimecategory != "All Crime Types") {
      selectdata <- subset(arrestdata, arrestdata$CRIME_CODE_CATEGORY_DESCRIPTION == as.character(input$crimecategory))
    }
    selectdata$Result <- as.character(selectdata$Result)
    selectdata$Result[is.na(selectdata$Result)] <- "UNKNOWN"
    selectdata$Result[selectdata$Result == "FALSE"] <- "UNKNOWN"
    white <- aggregate(selectdata$RACE_DESCRIPTION == "WHITE", list(as.character(selectdata$Result)),sum)
    black <- aggregate(selectdata$RACE_DESCRIPTION == "BLACK", list(as.character(selectdata$Result)),sum)
    asian <- aggregate(selectdata$RACE_DESCRIPTION == "ASIAN", list(as.character(selectdata$Result)),sum)
    hispanic <- aggregate(selectdata$RACE_DESCRIPTION == "HISPANIC", list(as.character(selectdata$Result)),sum)
    selectdata$RACE_DESCRIPTION <- as.character(selectdata$RACE_DESCRIPTION)
    selectdata$RACE_DESCRIPTION[selectdata$RACE_DESCRIPTION == "AMERICAN INDIAN/ALASKAN"] <- "OTHER"
    selectdata$RACE_DESCRIPTION[selectdata$RACE_DESCRIPTION == "ASIAN/PACIFIC ISLAND"] <- "OTHER"
    selectdata$RACE_DESCRIPTION[selectdata$RACE_DESCRIPTION == "UNKNOWN"] <- "OTHER"
    selectdata$RACE_DESCRIPTION[is.na(selectdata$RACE_DESCRIPTION)] <- "OTHER"
    other <- aggregate(selectdata$RACE_DESCRIPTION == "OTHER", list(as.character(selectdata$Result)),sum)
    # xlabel <- sort(as.character(unique(selectdata$Result)))
    xlabel <- as.character(unique(white$Group.1))
    
    highchart() %>% 
      hc_chart(type="column") %>% 
      hc_plotOptions(column = list(
        dataLabels = list(enabled = FALSE),
        stacking = "present",
        enableMouseTracking = FALSE)
      ) %>%
      hc_xAxis(categories = xlabel,
               tickmarkPlacement = 'on') %>% 
      hc_yAxis(title = list(text = "Persons")) %>% 
      hc_add_series(data=white$x, name = "White", color="cornflowerblue") %>%
      hc_add_series(data=black$x, name = "Black", color = "orange") %>%
      hc_add_series(data=hispanic$x, name = "Hispanic", color="green") %>%
      hc_add_series(data=asian$x, name = "Asian", color = "red") %>%
      hc_add_series(data=other$x, name = "Other", color="gray") %>%
      hc_add_theme(hc_theme_gridlight())
  })
  
  output$pieyuyan1 <-renderPlotly({
    if (input$crimecategory != "All Crime Types") {
      selectdata <- subset(arrestdata, arrestdata$CRIME_CODE_CATEGORY_DESCRIPTION == as.character(input$crimecategory))
    }
    whitepercent <- nrow(filter(selectdata, selectdata$RACE_DESCRIPTION == "WHITE"))#/nrow(selectdata)
    blackepercent <- nrow(filter(selectdata, selectdata$RACE_DESCRIPTION == "BLACK"))#/nrow(selectdata)
    asianpercent <- nrow(filter(selectdata, selectdata$RACE_DESCRIPTION == "ASIAN"))#/nrow(selectdata)
    hispanicpercent <- nrow(filter(selectdata, selectdata$RACE_DESCRIPTION == "HISPANIC"))#/nrow(selectdata)
    otherpercent <- nrow(filter(selectdata, selectdata$RACE_DESCRIPTION == "OTHER"))#/nrow(selectdata)
    pielabels = c("WHITE","BLACK","ASIAN","HISPANIC","OTHER")
    pievalues = c(whitepercent,blackepercent,asianpercent,hispanicpercent,otherpercent)
    percenttable <- cbind.data.frame(pielabels,pievalues)
    colnames(percenttable) <- c("RACE","PERCENT")
    
    plot_ly(percenttable, labels = percenttable$RACE, values = percenttable$PERCENT, type = 'pie') %>%
      layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$pieyuyan2 <-renderPlotly({
    if (input$crimecategory != "All Crime Types") {
      selectdata <- subset(arrestdata, arrestdata$CRIME_CODE_CATEGORY_DESCRIPTION == as.character(input$crimecategory))
    }
    other <- aggregate(selectdata$RACE_DESCRIPTION == "OTHER", list(as.character(selectdata$Result)),sum)
    selectdata$Result <- as.character(selectdata$Result)
    selectdata$Result[is.na(selectdata$Result)] <- "UNKNOWN"
    selectdata$Result[selectdata$Result == "FALSE"] <- "UNKNOWN"
    jail <- nrow(filter(selectdata, selectdata$Result == "TAKEN_TO_JAIL"))#/nrow(selectdata)
    bond <- nrow(filter(selectdata, selectdata$Result == "BONDED_OUT"))#/nrow(selectdata)
    indibond <- nrow(filter(selectdata, selectdata$Result == "INDIVIDUAL_BOND"))#/nrow(selectdata)
    comply <- nrow(filter(selectdata, selectdata$Result == "PROMISE_TO_COMPLY"))#/nrow(selectdata)
    nta <- nrow(filter(selectdata, selectdata$Result == "NOTICE_TO_APPEAR"))#/nrow(selectdata)
    unknown <- nrow(filter(selectdata, selectdata$Result == "UNKNOWN"))#/nrow(selectdata)
    pielabels2 = c("BONDED_OUT","INDIVIDUAL_BOND","NOTICE_TO_APPEAR","TAKEN_TO_JAIL","UNKNOWN")
    pievalues2 = c(bond,indibond,nta,jail,unknown)
    percenttable2 <- cbind.data.frame(pielabels2,pievalues2)
    colnames(percenttable2) <- c("RESOLUTION","PERCENT")
    
    plot_ly(percenttable2, labels = percenttable2$RESOLUTION, values = percenttable2$PERCENT, type = 'pie', color = '#FFFFFF') %>%
      layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  ############################ Updated Version ###################################
  output$plotyiyuan <- renderHighchart({
    highchart() %>% 
      hc_chart(type = "column") %>%
      hc_yAxis(title = list(text = "Number of arrests")) %>%
      hc_xAxis(categories=employment_xlabel) %>%
      hc_plotOptions(column = list(
        dataLabels = list(enabled = FALSE),
        stacking = "normal",
        enableMouseTracking = FALSE)
      ) %>% 
      hc_series(list(name="White",data=alldata$White,color="cornflowerblue"),
                list(name="Black",data=alldata$Black,color="orange"),
                list(name="Asian",data=alldata$Asian,color="green"),
                list(name="Hispanic",data=alldata$Hispanic,color="red"),
                list(name="Others",data=alldata$Other,color="gray"))
    
  })
  
  output$pieyiyuan1 <-renderPlotly({
    plot_ly(Unemployed, labels = Unemployed$Race, values = Unemployed$Number, type = 'pie') %>%
      layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  output$pieyiyuan2 <-renderPlotly({
    plot_ly(Employed, labels = Employed$Race, values = Employed$Number, type = 'pie') %>%
      layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
 
  output$textyiyuan1 = renderText({ 
    "This application provides tools to visualize characteristics of the arrested population in Champaign and Urbana from January 2010 to October 2016. Data for these tools come from the police departments in Champaign, Urbana, and the University of Illinois at Urbana-Champaign. Arrests include police incidents in which an individual is charged with a violation of the law. This means the arrest data includes data for individuals who were issued citations and traffic tickets, along with individuals who were charged with more serious crimes."
    })
  
 output$textyiyuan2 = renderText({    
    "Use the tabs above to navigate between tools that explore different aspects of the data. You can use the tools in each tab to compare the racial breakdown of arrested individuals based on a number of variables, such as crime type, age of arrestee, etc." 
    
    })
 output$textyiyuan3 = renderText({    
   "Introduction" 
 }) 
 
   output$textyiyuan4 = renderText({    
   "Instruction"   
 })  
   
}