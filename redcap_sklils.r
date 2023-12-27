
library(shiny)
library(dplyr)

# Load your data from the CSV file
skills_data <- read.csv("/Users/hale75/Desktop/redcap_dev_skills_v1.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("REDCap Development Team Skills"),
  sidebarLayout(
    sidebarPanel(
      selectInput("skillType", "Select Skill Type", 
                  choices = unique(skills_data$skill_type))
    ),
    mainPanel(
      uiOutput("skillDetails")
    )
  )
)

server <- function(input, output) {
  output$skillDetails <- renderUI({
    # Filter data based on selected skill type
    selected_data <- filter(skills_data, skill_type == input$skillType)
    
    # Create UI elements dynamically
    skill_list <- lapply(split(selected_data, selected_data$skill_order), function(skill_group) {
      sub_skills <- skill_group[skill_group$sub_skill_order > 0,]
      sub_skills_list <- if(nrow(sub_skills) > 0) tags$ul(lapply(sub_skills$description, tags$li)) else NULL
      
      wellPanel(
        h3(skill_group$specific_skill[1]),
        p(skill_group$description[1]),
        sub_skills_list
      )
    })
    
    do.call(tagList, skill_list)
  })
}

shinyApp(ui, server)
