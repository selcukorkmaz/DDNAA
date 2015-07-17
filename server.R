shinyServer(function(input, output, session){
	library(caret)
    library(plyr)
	load("model.rda")
    load("bagSVM.rda")
    load("bagKNN.rda")
	load("Parameters.rda")  ## stores PreProcessing (z-score) parameters
	source("prediction.R")  ## Function for prediction of new sample(s)
    source("bagPrediction.R")
	
	# Return the requested leukocyte count
	leukCount <- reactive({
		as.numeric(input$leuk)
	})
	
	# Return the requested d-dimer level
	ddimerLevel <- reactive({
		as.numeric(input$ddimer)
	})
	
	observe({
		if (input$showEx){  ## update numeric input via show example check
            #updateNumericInput(session, inputId = "leuk", value=33000)
            #updateNumericInput(session, inputId = "ddimer", value=8.09)
            updateTextInput(session, inputId = "leuk", value="33000")
            updateTextInput(session, inputId = "ddimer", value="8.09")
		}
	})
	
	observe({
		if (input$ddimer != "8.09" | input$leuk != "33000"){
			updateCheckboxInput(session, "showEx", value = FALSE)
		}
	})
	
	# New data is saved as a row vector (1xp)
	dataInput <- reactive({
        raw = matrix(c(ddimerLevel(), log(leukCount(), base=10)), ncol=2)
        zscore = (raw - param$Mean) / param$Std.Dev.
        return(zscore)
    })
	
	output$DDNAA <- renderPrint({
		if (input$leuk != "Enter leukocyte count" | input$ddimer != "Enter d-dimer level"){
			test = dataInput()
			colnames(test) = c("ddimer","logwbc")

			pred = lapply(model, FUN=function(x){
									prediction(x, newdat=test)})

            bagSVMs = bag.prediction(bagSVM.models, test)
            bagSVM.pred = c("Not Needed","Needed")[as.numeric(apply(bagSVMs, 1, function(x)names(which.max(table(x)))))]
            
            bagKNNs = bag.prediction(bagKNN.models, test)
            bagKNN.pred = c("Not Needed","Needed")[as.numeric(apply(bagKNNs, 1, function(x)names(which.max(table(x)))))]
                        
                cat("  Table 1. Statistical Learning Results", "\n")
                cat("----------------------------------------------------------------------", "\n")
                cat("  Diagnostic Test                              Immediate Laparotomy","\n")
                cat("----------------------------------------------------------------------", "\n")
            
            if(pred[1] == "Needed"){
                cat("  Naive Bayes                                      Needed", "\n")
            }
            
            if(pred[1] == "Not Needed"){
                cat("  Naive Bayes                                      Not Needed", "\n") # Naive Bayes result
            }
            
            if(pred[2] == "Needed"){
                cat("  Robust Quadratic Discriminant Analysis           Needed", "\n")
            }
        
            if(pred[2] == "Not Needed"){
                cat("  Robust Quadratic Discriminant Analysis           Not Needed", "\n") # Robut QDA result
            }
            
            if(pred[3] == "Needed"){
                cat("  k-Nearest Neighbors                              Needed", "\n")
            }
            
            if(pred[3] == "Not Needed"){
                cat("  k-Nearest Neighbors                              Not Needed", "\n") # knn result
                
            }
            
            if(bagSVM.pred == "Needed"){
                cat("  Bagged Support Vector Machines                   Needed", "\n")
            }
            
            if(bagSVM.pred == "Not Needed"){
                cat("  Bagged Support Vector Machines                   Not Needed", "\n") # bSVM result
            }
            
            if(bagKNN.pred == "Needed"){
                cat("  Bagged k-Nearest Neighbors                       Needed", "\n")
            }
            
            if(bagKNN.pred == "Not Needed"){
                cat("  Bagged k-Nearest Neighbors                       Not Needed", "\n") # bSVM result
            }

                cat("----------------------------------------------------------------------")
                                         
                cat("\n\n\n")
                
                cat("  Table 2. Single Test Results", "\n")
                cat("------------------------------------------------------------------------------------------", "\n")
                cat("  Diagnostic Test                              Immediate Laparotomy    Cut-off Value (*)    ","\n")
                cat("------------------------------------------------------------------------------------------", "\n")
                
            if(leukCount() > 14200){
                cat("  Leukocyte count                                  Needed                  > 14200", "\n")
            }
            
            if(leukCount() <= 14200){
                cat("  Leukocyte count                                  Not Needed              > 14200", "\n")
            }
            
            if(ddimerLevel() > 1.6){
                cat("  D-dimer level                                    Needed                  > 1.6", "\n")
            }
            
            if(ddimerLevel() <= 1.6){
                cat("  D-dimer level                                    Not Needed              > 1.6", "\n")
            }
                cat("-------------------------------------------------------------------------------------------", "\n")
	
		}
	})
    
    
    #output$downloadDDNAAresult <- downloadHandler(
    #filename = function() { "results.txt" },
    #content = function(file) {
	#	write.table(DDNAA, file, row.names=FALSE, quote=FALSE, sep="\t")
    #})
    
    
    

	
    output$clock <- renderText({ #sistem saati
		invalidateLater(1000, session)
		paste("The current time is", Sys.time())
	})	
})



#	observe({
#		if (input$action_button == 0) # tells action button to do nothing when not clicked ..
#  		return()
#	isolate({ # this isolates the code you want to execute when clicking the action button..
#			  # some function or conditional panel
#	})
#	})




