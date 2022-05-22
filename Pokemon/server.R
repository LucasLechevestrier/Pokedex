#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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
library(fmsb)
library(ECharts2Shiny)

pokemon <- read_csv("./pokemon.csv")
pkm<-pokemon
pkm<-rename(pkm, Type_2="Type 2")
pkm<-rename(pkm, Type="Type 1")
pkm <- subset (pkm, select = -c(Type_2))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$pokemonPlot1 <- renderPlotly({
        pkm1<- filter(pkm,Generation==input$generation)
        principal_types = c("Fire","Grass","Electric","Ground","Water")
        pkm1<- mutate(pkm1,Types= if_else(Type%in%principal_types, Type, "Other_Types", missing = NULL))
        plot1<-ggplot(pkm1, aes(labels=Name, x=Defense, y=Attack, color=Types))+geom_point()+scale_color_manual(breaks = c("Fire","Grass","Electric","Ground","Water","Other_Types") ,values=c("red", "green", "yellow","brown", "blue","grey"))+ggtitle("Attack and defense")
        plot1<-ggplotly(plot1, tooltip = c("Defense", "Attack","Type","Name"))
        plot1
        })
    
    output$text1 <- renderText(
        paste(paste("There are ",nrow(filter(pkm,Generation==input$generation))),"pokemons in this generation")
    )
    
    output$pokemonPlot2 <- renderPlotly({
        pkm2<-pokemon
        pkm2<-rename(pkm2, Type_2="Type 2")
        pkm2<-rename(pkm2, Type="Type 1")
        pkm2<- subset(pkm2, select = -c(Type_2))
        pkm2<- filter(pkm2,Legendary==TRUE)
        pkm2<- filter(pkm2,Type==input$type)
        pkm2<-select(pkm2,c("Name","HP","Total",input$box))

        pkm2 <- ggparcoord(pkm2,columns = 2:ncol(pkm2), groupColumn = 1)
        ggplotly(pkm2, tooltip = c("Name", "value","variable"))
    })
    
    output$radarchart<-renderPlot({
        pkm3<-pokemon
        pkm3<-rename(pkm3, Type_2="Type 2")
        pkm3<-rename(pkm3, Id="#")
        pkm3<-rename(pkm3, Type="Type 1")
        pkm3<- filter(pkm3,Legendary==TRUE)
        pkm3<- subset(pkm3, select = -c(Type_2,Id,Type,Generation,Total,Legendary))
        pkm3<-rename(pkm3, Sp_Atk="Sp. Atk")
        pkm3<-rename(pkm3, Sp_Def="Sp. Def")
        pkm3<- filter(pkm3,Name=="Articuno")
        
        chart<-data.frame(HP=c(150,90,pkm3$HP[1]),
                          Attack=c(190,75,pkm3$Attack[1]),
                          Defense=c(200,70,pkm3$Defense[1]),
                          Sp_Atk=c(194,90,pkm3$Sp_Atk[1]),
                          Sp_Def=c(200,85,pkm3$Sp_Def[1]),
                          Speed=c(180,85,pkm3$Speed[1]))
        radarchart(chart, pcol='blue',cglcol='red')
    })
    
    output$table_chart<-DT::renderDataTable({
        pkm3<-pokemon
        pkm3<-rename(pkm3, Type_2="Type 2")
        pkm3<-rename(pkm3, Id="#")
        pkm3<-rename(pkm3, Type="Type 1")
        pkm3<- filter(pkm3,Legendary==TRUE)
        pkm4<-pkm3
        pkm4<- subset(pkm4, select = -c(Type_2,Id,Type,Generation,Total,Legendary))
        DT::datatable(pkm4, extensions = 'Scroller', options=list(deferRender=TRUE, scrollY = 200, scroller=TRUE))
    })
    
    output$barPlot<-renderPlotly({
        pkm5<-pkm
        pkm5<-filter(pkm5,Total>input$total)
        barchart<-ggplot(pkm5, aes(x=Type,color=Type, fill=Type))+geom_bar()+coord_flip()+ylab("Pokemon number of each type")+theme(legend.position = "none",panel.background = element_rect(fill="white",color="white"),axis.title.y=element_blank())
        ggplotly(barchart,tooltip = "count")
    })
    
    output$text2 <- renderText(
        paste("The cumulated point is the sum of the following attributes : HP, Attack, Defense, Speed, Special Attack and Special Defense")
    )
    
    output$favorite<-renderPlot({
        pkm6<-pkm
        pkm6<-filter(pkm6,Name%in% c("Bulbasaur","Pikachu","Meowth"))
        ggplot(pkm6, aes(x=HP, y=Speed, size=5))+geom_point()+theme(legend.position="none",panel.grid = element_line(color = "#8ccde3",
                                                                                                                     size = 0.75,
                                                                                                                     linetype = 2))
    })
    
    output$favorite2<-renderPlot({
        pkm6<-pkm
        pkm6<-filter(pkm6,Name%in% c("Bulbasaur","Pikachu","Meowth"))
        x_mouse<- function(e){
            if(is.null(e)) return(40)
            return(round(e$x, 1))
        }
        
        
        if(x_mouse(input$mouse)>42.5)
            pkm7<-filter(pkm6, Name=="Bulbasaur")
        if(x_mouse(input$mouse)<42.5)
            pkm7<-filter(pkm6, Name=="Meowth")
        if(x_mouse(input$mouse)<37.5)
            pkm7<-filter(pkm6, Name=="Pikachu")
        ggplot(pkm7,aes(x=Attack,y=Defense,size=5))+geom_point() + 
            scale_x_continuous(limits = c(40, 60))+scale_y_continuous(limits = c(30, 60))+theme(legend.position="none",panel.grid = element_line(color = "#8ccde3",
                                                                                                                                                 size = 0.75,
                                                                                                                                                 linetype = 2))
    })
    output$text3<-renderText({
        pkm6<-pkm
        pkm6<-filter(pkm6,Name%in% c("Bulbasaur","Pikachu","Meowth"))
        x_mouse<- function(e){
            if(is.null(e)) return(40)
            return(round(e$x, 1))
        }
        
        
        if(x_mouse(input$mouse)>42.5)
            pkm7<-filter(pkm6, Name=="Bulbasaur")
        if(x_mouse(input$mouse)<42.5)
            pkm7<-filter(pkm6, Name=="Meowth")
        if(x_mouse(input$mouse)<37.5)
            pkm7<-filter(pkm6, Name=="Pikachu")
        paste(pkm7$Name, "is the pokemon selected")
    })
    
    output$text4<-renderText("You can select a pokemon by clicking on a specific point ")
    

})
