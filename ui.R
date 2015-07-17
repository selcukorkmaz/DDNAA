shinyUI(pageWithSidebar(

	titlePanel(title="DDNAA: Decision support system for differential diagnosis of nontraumatic acute abdomen"),

	sidebarPanel(
		conditionalPanel(condition="input.tabs1=='Introduction'",
            HTML('<p align="center"><img src="abdominalpain.jpg" width=300 height=300></p>'),
            tags$head(includeScript("google-analytics.js"))

        ),

		conditionalPanel(condition="input.tabs1=='Analyze'",
			h4("Enter your data"),
            #numericInput(inputId = "leuk", label = "Leukocyte count", value=0, min=0, max=1000000, step=1),
            #numericInput(inputId = "ddimer", label = "D-dimer level (µg FEU/ml)", value=0, min=0, max=1000000, step=0.0001),

            textInput(inputId = "leuk", label = "Leukocyte count", value="Enter leukocyte count"),
            textInput(inputId = "ddimer", label = "D-dimer level (µg FEU/ml)(†)", value="Enter d-dimer level"),
			HTML('<br>'),
			checkboxInput("showEx", "Load example", FALSE),
			#actionButton("runPred", "Submit")
            HTML('<br>'),
            helpText("Note: Use . as delimiter")
		),
		
        conditionalPanel(condition="input.tabs1=='Manual'",
			HTML('<p align="center"><img src="manual.png" width=200 height=200></p>')
        ),

        conditionalPanel(condition="input.tabs1=='News'",
            HTML('<p align="center"><img src="news.png" width=200 height=200></p>')
        ),

        conditionalPanel(condition="input.tabs1=='Authors'",
            column(6, HTML('<p><a href="http://www.erciyes.edu.tr/en/" target="_blank"><img src="erciyes.JPEG" width=125 height=125></a> </p>')),
            column(6, HTML('<p><a href="https://www.hacettepe.edu.tr/english/" target="_blank"><img src="hu_logo.JPEG" width=125 height=125></a> </p>')),
            HTML('<br>'),
            HTML('<br>'),
            HTML('<br>'),
            HTML('<br>'),
            HTML('<br>'),
            HTML('<br>'),
            HTML('<br>'),
            HTML('<br>')
        ),

conditionalPanel(condition="input.tabs1=='Citation'",
HTML('<p align="center"><img src="cite.png" width=200 height=200></p>')
)
    ),

	mainPanel(
		tabsetPanel(
			tabPanel("Introduction",
HTML('<p align = "justify"> A quick evaluation is required for patients with acute abdominal pain. It is crucial to differentiate between surgical and nonsurgical pathology. Practical and accurate tests are essential in this differentiation. Lately, D-dimer level is found to be an important adjuvant in this diagnosis and obviously outperforms leukocyte count, which is widely used for diagnosis of certain cases [1,2]. Here, we handle this problem in a statistical perspective and combine the information from leukocyte count along with D-dimer level to increase the diagnostic accuracy of nontraumatic acute abdomen. For this purpose, various statistical learning algorithms are considered and model performances are assessed using several measures. Our results revealed that naïve Bayes, robust quadratic discriminant analysis, bagged and boosted support vector machines, single and bagged k-nearest neighbors provide an increase in diagnostic accuracies up to 8.93% and 17.86%, compared with D- dimer level and leukocyte count, respectively. Highest accuracy was obtained as 78.57% with naïve Bayes algorithm. A user-friendly web-tool is also developed to assist physicians in their decisions to differentially diagnose of patients with acute abdomen [3].</p>'),

                    HTML('<br>'),
                    h5('References'),

					h6("[1] H.Y. Akyildiz, A. Akcan, A. Ozturk, E. Sozuer, C. Kucuk, A. Yucel, D-dimer as a predictor of the need for laparotomy in patients with unclear non-traumatic acute abdomen. A preliminary study, Scandinavian Journal of Clinical & Laboratory Investigation 68(7). (2008) 612-7. doi:10.1080/00365510801971729."),
					h6("[2] H.Y. Akyildiz, E. Sozuer, A. Akcan, C. Kucuk, T. Artis, I. Biri, N. Yilmaz, The value of D-dimer test in the diagnosis of patients with nontraumatic acute abdomen, Turkish Journal of Trauma & Emergency Surgery 16 (1). (2010) 22-26."),
                    h6("[3] G. Zararsiz, D. Goksuluk, S. Korkmaz, A. Ozturk, H.Y. Akyildiz, Statistical learning approaches in diagnosing patients with nontraumatic acute abdomen Turkish Journal of Electrical Engineer and Computer Science (2015) Accepted/In press."),

					HTML('<br>'),
                 #  HTML('<p> ----------------------------------------------------------- </p>'),

					textOutput("clock"),
                    HTML('<br>'),
                    h6('Disclaimer: All images, designs or videos in this page are copyright of their respective owners. We do not own have these images, designs or videos. We collect them from search engine and other sources to be used as ideas for you. No copyright infringement is intended. If you have reason to believe that one of our content is violating your copyrights, please do not take any legal action. You can contact us directly to be credited or have the item removed from the site.')
			),

			tabPanel("Analyze",
                #Download butonlarini koymak istersek bu kismi aktif ederiz.
				#downloadButton("downloadPlotPDF", "Download plot as pdf-file"),
				#downloadButton("downloadPlotPNG", "Download plot as png-file"),
                #downloadButton("downloadMVNData", "Download data set as txt-file"),
                #downloadButton("downloadDDNAAresult", "Download results as txt-file"),
				 h4("Results"),
				 verbatimTextOutput("DDNAA"),
                 HTML('<br>'),
                 HTML('<p>(†) D-dimer assay: MDA® D-dimer, bioMérieux, Durham, North Carolina, USA, normal value > 0.6 μg fibrinogen equivalent units (FEU)/ml.</p>'),

                 #HTML('<br>'),

                 HTML('<p>(*) H.Y. Akyildiz, E. Sozuer, A. Akcan, C. Kucuk, T. Artis, I. Biri, N. Yilmaz, The value of D-dimer test in the diagnosis of patients with nontraumatic acute abdomen, Turkish Journal of Trauma & Emergency Surgery 16 (1). (2010) 22-26.</p>')

				 #plotOutput("outlierPLOT")  ## Grafik çiktilari istenirse bu bölüm aktif edilecek.
            ),

            tabPanel("Manual",
				##  Programin nasil kullanilacagina dair bir manuel vermek iyi olur diye dusunuyorum (dincer).
				##  Bir kac madde ile hangi buton ne işe yarar, sonuçlar nasil yorumlanir şeklinde bir açiklama ekleyelim.

				h5("Usage of the web-tool"),
				HTML('<p>In order to use this application,</p>'),
				HTML("<p> (i) enter your data which includes leukocyte count and D-dimer level of the patient using Analyze tab. Notice that the D-dimer assay method is MDA®, the unit of D-dimer level is 'µg FEU/ml' (e.g. 8.09) and the unit of leukocyte is count (e.g. 33000).</p>"),
				HTML('<p> (ii) check the results (immediate laparotomy needed or not needed) in the same tab for each statistical learning and single diagnostic tests.</p>'),
				HTML('<br>'),
				HTML('<p> <b>Please note that DDNAA tool is developed as a decision support based on [1,2] and the results may not always be correct.</b></p>'),
				h6(" [1] G. Zararsiz, D. Goksuluk, S. Korkmaz, A. Ozturk, H.Y. Akyildiz, Statistical Learning Approaches in Diagnosing Patients with Nontraumatic Acute Abdomen,Under review in Turkish Journal of Electrical Engineering and Computer Science."),
				h6(" [2] H.Y. Akyildiz, E. Sozuer, A. Akcan, C. Kucuk, T. Artis, I. Biri, N. Yilmaz, The value of D-dimer test in the diagnosis of patients with nontraumatic acute abdomen, Turkish Journal of Trauma & Emergency Surgery 16 (1). (2010) 22-26.")
            ),

			tabPanel("Authors",
                ## Kisisel web adresine (akademik sayfa) link yönlendirmesi yapilacak ise, Selcuk'un ismindeki kodlar kullanilabilir. Hacettepe sayfalarimiza yonlendirebiliriz (gokmen).
                h4("Authors"),
				##h5("Gokmen Zararsiz"),
				HTML('<p><a href="http://www.biostatistics.hacettepe.edu.tr/cv/Gokmen_Zararsiz_CV_Eng.pdf" target="_blank"> <b>Gokmen Zararsiz (M.Sc)</b></a><p>'),
                HTML('<p>Hacettepe University Faculty of Medicine <a href="http://www.biostatistics.hacettepe.edu.tr" target="_blank"> Department of Biostatistics</a><p>'),
                HTML('<p><a href="mailto:gokmen.zararsiz@hacettepe.edu.tr" target="_blank">gokmen.zararsiz@hacettepe.edu.tr</a><p>'),

				HTML('<p><a href="http://www.biostatistics.hacettepe.edu.tr/cv/Dincer_Goksuluk_CV_Eng.pdf" target="_blank"> <b>Dincer Goksuluk (M.Sc)</b></a><p>'),
                HTML('<p>Hacettepe University Faculty of Medicine <a href="http://www.biostatistics.hacettepe.edu.tr" target="_blank"> Department of Biostatistics</a><p>'),
                HTML('<p><a href="mailto:dincer.goksuluk@hacettepe.edu.tr" target="_blank">dincer.goksuluk@hacettepe.edu.tr</a><p>'),

                HTML('<p><a href="http://yunus.hacettepe.edu.tr/~selcuk.korkmaz/" target="_blank"> <b>Selcuk Korkmaz (M.Sc)</b></a><p>'),
                HTML('<p>Hacettepe University Faculty of Medicine <a href="http://www.biostatistics.hacettepe.edu.tr" target="_blank"> Department of Biostatistics</a><p>'),
                HTML('<p><a href="mailto:selcuk.korkmaz@hacettepe.edu.tr" target="_blank">selcuk.korkmaz@hacettepe.edu.tr</a><p>'),

                HTML('<p><a href="http://aves.erciyes.edu.tr/ahmetozturk/kimlik" target="_blank"> <b>Ahmet Ozturk (Ph.D)</b></a><p>'),
                HTML('<p>Erciyes University Faculty of Medicine <a href="http://biyoistatistik.erciyes.edu.tr/" target="_blank"> Department of Biostatistics</a><p>'),
                HTML('<p><a href="mailto:ahmetozturk@erciyes.edu.tr" target="_blank">ahmetozturk@erciyes.edu.tr</a><p>'),

                HTML('<p><a href="http://aves.erciyes.edu.tr/hyakyildiz/" target="_blank"> <b>Hizir Yakup Akyildiz (MD)</b></a><p>'),
                HTML('<p>Erciyes University Faculty of Medicine <a href="http://hastaneler.erciyes.edu.tr/Servisler/genel_cerrahi.asp" target="_blank"> Department of General Surgery</a><p>'),
                HTML('<p><a href="mailto:hkakyildiz@gmail.com" target="_blank">hyakyildiz@gmail.com</a><p>'),

                HTML('<br>'),
                h6("Please feel free to send us bugs and feature requests.")
            ),

            tabPanel("News",
                h5("Version 1.0 (September 26, 2014)"),
                HTML('<p>(1) DDNAA web-tool has been released. <p>'),

                HTML('<br>'),

                h5("Other Tools"),

                HTML('<p><a href="http://www.biosoft.hacettepe.edu.tr/easyROC/" target="_blank"> <b>easyROC: a web-tool for ROC curve analysis </b></a><p>'),
                HTML('<p><a href="http://www.biosoft.hacettepe.edu.tr/MVN/" target="_blank"> <b>MVN: a web-tool for assessing multivariate normality </b></a><p>'),
                HTML('<p><a href="http://www.biosoft.hacettepe.edu.tr/MLViS/" target="_blank"> <b>MLViS: machine learning-based virtual screening tool </b></a><p>')
            ),

            tabPanel("Citation",

                h5("If you use this tool for your research please cite:"),
                HTML('<p>Zararsiz G, Goksuluk D, Korkmaz S, Ozturk A, Akyildiz HY (2015) "Statistical learning approaches in diagnosing patients with nontraumatic acute abdomen" Turkish Journal of Electrical Engineer and Computer Science, Accepted/In press. </a><p>')
        ),

            id="tabs1"
		),

        tags$head(tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
        tags$style(type="text/css", "select { max-width: 200px; }"),
        tags$style(type="text/css", "textarea { max-width: 185px; }"),
        tags$style(type="text/css", ".jslider { max-width: 200px; }"),
        tags$style(type='text/css', ".well { max-width: 330px; }"),
        tags$style(type='text/css', ".span4 { max-width: 330px; }")),
        tags$head(tags$link(rel = "shortcut icon", href = "favicon-6.ico"))	
	)
 ))




