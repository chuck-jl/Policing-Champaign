# Policing data analysis and visulization for Champaign County
This project is aiming to gather and organize the policing data in different jurisdiction of Champaign County and provide suitable visulization for the public to understand the trends and amounts of arrests happened in the county from 2010 to 2016.
The project page mainly consists of two parts: Data and Application.
##Data
The analysis of policing information in Champaign-Urbana Metropolitan Area was based on the analysis of arrest data collected in Area-wide Record Management System (A.R.M.S.) of the following Police Departments:
1.	City of Champaign
2.	City of Urbana 
3.	University of Illinois
The required data was requested through Freedom of Information Act (FOIA request) and provided in the format of .csv files for the period since January 1st2010 until November 2016 (last records in the system). The analyzed police departments basically cover Champaign-Urbana urbanized area. 
The data for the Village of Rantoul and Champaign County Sheriff was not used in the research due to the difference in the format of its collection. The Village of Rantoul Police Department has joined the A.R.M.S. agreement only after August 2014 and the County Sheriff office has started to collect the data in the same format since the beginning of 2015, thus the data can not be fully integrated with Champaign, Urbana and the University of Illinois police departments data. Sheriff and Rantoul data, as well as all provided incident data were not used in this project.
##Application
For the visulization purposes, our group created a visulization application for the data we gathered. Based on the R Shiny platform, the application provides tools to visualize characteristics of the arrested population in Champaign and Urbana from January 2010 to October 2016. Data for these tools come from the police departments in Champaign, Urbana, and the University of Illinois at Urbana-Champaign. Arrests include police incidents in which an individual is charged with a violation of the law. This means the arrest data includes data for individuals who were issued citations and traffic tickets, along with individuals who were charged with more serious crimes.
##Final Product Example
The live sample of the application is available at: https://yhung133.shinyapps.io/Project_Final/
