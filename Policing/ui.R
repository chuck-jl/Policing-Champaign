
navbarPage("Policing data analysis for Champaign County",
                 tabPanel("Welcome",
                          br(),
                          br(),
                          br(),
                          br(),
                          br(),
                          br(),
                          fluidRow(
                          box(
                          width = 3, status = "info", solidHeader = TRUE, align= "center",  style = "color: navy ; font-size: 30px; font-style:bold",
                           textOutput("textyiyuan3") 
                                   ),
                          box(
                            width = 6, status = "info", solidHeader = TRUE, style = "color: black ; font-size: 16px",
                            textOutput("textyiyuan1") 
                          )
                          ),
                          br(),
                          br(),
                          br(),
                          br(),
                          br(),
                          br(),
                          fluidRow(
                            box(
                                width = 3, status = "info", solidHeader = TRUE,align= "center",style = "color: navy ; font-size: 30px;font-style:bold",
                              textOutput("textyiyuan4") 
                            ),
                            box(
                              width = 6, status = "info", solidHeader = TRUE,style = "color: black ; font-size: 16px",
                              textOutput("textyiyuan2") 
                            )
                          )
                          ),
                          
                          
                          
                          
                   tabPanel("Summary", 
                      fluidRow(
                        box(width = 3,status = "info", solidHeader = TRUE,
                            title = "Description",
                            helpText("    This page provides a general visulization about the distribution and trend about the arrests happeneded in Champaign county with the policing data from all three jurisdiction provided in our database."),
                            helpText("The graph on the right provides an visulization about the numbers of arrests happened in Champaign county based on the Race of the arrestees in quarter-year time series."),
                            helpText("The three pie charts listed below intended to provide additional information about the population distribution, total arrest summary and distribution based on jurisdictions.")
                            ),
                        box(
                          width = 9, status = "info", solidHeader = TRUE,
                          title = "Total arrests distribution in Champaign by Race",
                          #       plotOutput("plot1")
                          highchartOutput("plot1") 
                        )
                      ),
                      fluidRow(
                        box(
                          width = 4, status = "info",
                          title = "Population distribution of Champaign county by Race",
                          tabsetPanel(
                            tabPanel("Summary",plotlyOutput("pie1")),
                            tabPanel("Table",tableOutput("table1"))
                          )
                        ),box(
                          width = 4, status = "info",
                          title = "Total Arrests Summary",
                          tabsetPanel(
                            tabPanel("Summary",plotlyOutput("pie2")),
                            tabPanel("Table",tableOutput("table2"))
                          )
                        ),
                        box(
                          width = 4, status = "info",
                          title = "Arrests distribution of Champaign county by jurisdiction",
                          tabsetPanel(
                            tabPanel("Summary",plotlyOutput("pie21")),
                            tabPanel("Table",tableOutput("table21"))
                          )
                        )
                        
                      )  
                      ),
                      tabPanel("Resolution",
                               fluidRow(
                                 box(
                                   width = 12, status = "info", solidHeader = TRUE,
                                   title = "Resolution Type For Different Crimes By Race (2010 - Present)",
                                   fluidPage(
                                     sidebarLayout(
                                       sidebarPanel(
                                         selectInput("crimecategory", "Select Crime Type", 
                                                     choices = as.list(sort(choices)), selected="."),
                                         helpText("Description:"),
                                         helpText("'Resolution type' refers to what happens to the individual 
                                                  after he or she is arrested. In total, there are six possible resolution 
                                                  types: bonded out, individual bond, notice to appear, promise to comply, 
                                                  taken to jail, and unknown. These categories for resolution types appear 
                                                  as they are listed in the ARMS data."),
                                         helpText("Using the drop-down menu above, select 
                                                  a type of crime to explore how arrests for this crime were resolved. The chart 
                                                  allows for comparisons across racial categories.")
                                         ),
                                       mainPanel(
                                         highchartOutput("plotyuyan1")
                                       ))))
                                     ),
                               fluidRow(
                                 box(
                                   width = 6, status = "info", solidHeader = TRUE,
                                   title = "Race of Individuals Arrested For Selected Crime",
                                   plotlyOutput("pieyuyan1")
                                 ),
                                 box(
                                   width = 6, status = "info", solidHeader = TRUE,
                                   title = "Resolution Type For Arrests For Selected Crime",
                                   plotlyOutput("pieyuyan2")
                                 )
                               )
                               ),
                      tabPanel("Employment",
                               fluidRow(
                                 box(
                                   width = 2, status = "info", solidHeader = TRUE,
                                   title = "Description",
                                   helpText("This interactive chart on the right shows the employment status of the arrestees from 2010 to 2016. Click on each racial category to make it appear or disappear in the chart.")
                                 ),
                                 box(
                                   width = 8, status = "info", solidHeader = TRUE,
                                   title = "Employment Status of Arrestees",
                                   highchartOutput("plotyiyuan") 
                                 )
                               ),
                               fluidRow(
                                 box(
                                   width = 6, status = "info", solidHeader = TRUE,
                                   title = "Racial Status in Arrestees Who are Unemployed",
                                   plotlyOutput("pieyiyuan1")
                                 ),
                                 box(
                                   width = 6, status = "info", solidHeader = TRUE,
                                   title = "Racial Status in Arrestees Who are Employed",
                                   plotlyOutput("pieyiyuan2") 
                                 )
                               )
                                 ),
                      tabPanel("Age",
                               fluidRow(
                                 box(
                                   width = 10, status = "info", solidHeader = TRUE,
                                   title = "Distribution by Race and Age",
                                   #            plotOutput("plot")
                                   highchartOutput("plot") 
                                 )
                                 ),
                               fluidRow(
                                 box(
                                   width = 4, status = "info",
                                   title = "Top 10 Crime Categories for arrestees under 18",
                                   tableOutput("table3")
                                 ),
                                 box(
                                   width = 5, status = "info",
                                   title = "Race of arrestees under 18",
                                   plotlyOutput("pie3")
                                 )
                               )
                                 ),
                      tabPanel("Rawdata", 
                               tabsetPanel(
                                 tabPanel("Arrests",
                                          numericInput("maxrows", "Rows to show", 25, min=1, max=1000),
                                          verbatimTextOutput("arrests"),
                                          downloadButton("downloadCsv", "Download All Data as CSV")),
                                 tabPanel("Arrestees",
                                          numericInput("maxrows1", "Rows to show", 25, min=1, max=1000),
                                          verbatimTextOutput("arrestees"),
                                          downloadButton("DownloadCsv", "Download All Data as CSV")
                                          )
                                 )
                               )
           )