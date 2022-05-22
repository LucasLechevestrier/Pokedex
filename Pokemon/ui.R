#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(flexdashboard)
library(GGally)
library(ggsci)
library(readr)
library(ggplot2)
library(tidyr)
library(dplyr)
library(plotly)
library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        navbarPage("Pokedex",
                tabPanel("About",
                         fluidRow(img(src="logo.jpg", height = 100, width = 800),
                           column(6,
                                         h2("Welcome to the Pokemon world that you can discover and compare various features of the pokemons!"),
                                         h4("In the Attack/Defense section, the attack and defense points of every pokemon from all generations can be observed from the plot. Also, The types of pokemons are illustrated with different colors."),
                                         h4("To discover which pokemon type is better in general, please go to the Types section."),
                                         h4("In the Comparison subsection, you can compare the same type legendary pokemons. Also, you can specify the attributes that you want to analyze. Values for features of pokemons are normalized. The real values can be found in the One by one subsection. Moreover, at the bottom of the section,  by clicking a pokemon in data table, the attributes of the pokemon can be observed.
                                           "),
                                         h4(" We have compiled our own favorite pokemons in our favorites section.")),
                                  column(6,
                                         img(src="pokemons.jpg", height = 600, width = 350)))),
                tabPanel("Attack/Defense",
                
                fluidRow(column(5,
                                numericInput(inputId = "generation",
                                             label = "Generation to view:",
                                             value = 1, min=1, max=5),
                                textOutput(outputId = "text1"),
                                img(src="pokedex.png", height = 250, width = 350),
                                ),
                         column(7,
                                plotlyOutput(outputId = "pokemonPlot1")
                                ))
                ),
                tabPanel("Types", sidebarLayout(
                  sidebarPanel(
                    sliderInput("total",
                                "Minimal number of cumulated points:",
                                min = 200,
                                max = 600,
                                value = 400),
                    textOutput(outputId = "text2"),
                    img(src="pikachu.png", height = 200, width = 200)
                  ),
                  mainPanel(
                    plotlyOutput("barPlot")
                  ),
                )),
                navbarMenu("Legendary",
                           tabPanel("Comparison",
                                    h4("Comparison of legendary pokemons by type"),
                                    plotlyOutput(outputId = "pokemonPlot2"),
                                    fluidRow(column(3,
                                                    checkboxGroupInput("box","Attributes", c("Attack"="Attack","Defense"="Defense","Sp. Atk"="Sp. Atk","Sp. Def"="Sp. Def","Speed"="Speed"))),
                                             column(5,
                                                    textInput("type","Type", value="Grass", placeholder = c("Electric","Water","Grass","Fire","Dragon","Rock"))),
                                             column(4,
                                                    img(src="dracofeu.png", height = 200, width = 200)))),
                           
                tabPanel("One by one",
                         fluidRow(column(12,
                                         DT::dataTableOutput("table_chart"))
                                  ),
                         fluidRow(column(3,
                                         br("_____________________________"),
                                         img(src="pokeball.png", height = 230, width = 230)
                                         ),
                                  column(5,
                                         plotOutput("radarchart")),
                                  column(3,
                                         br("_____________________________"),
                                         img(src="pokeball.png", height = 230, width = 230)
                                  )))),
                tabPanel("Our favorites",
                         fluidRow(column(4,
                                         img(src="pikachu.png", height = 230, width = 230)),
                                  column(4,
                                         img(src="bulbasaur.png", height = 230, width = 230)),
                                  column(4,
                                         img(src="meowto.png", height = 230, width = 230))),
                         fluidRow(column(6,
                                         textOutput("text4"),
                                         plotOutput("favorite",click="mouse")
                                         ),
                                  column(6,
                                         textOutput("text3"),
                                         plotOutput("favorite2")))
                         )
        
)))
