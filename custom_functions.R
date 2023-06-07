
# functions ---------------------------------------------------------------


showNA <- function(df) {
  
  df <- df %>% 
    summarize_all(
      funs(
        (round(sum(is.na(.))*100 / length(.), 
               digits = 2)
        )
      )
    ) %>%
    t()
  
  df <- setDT(as.data.frame(df), keep.rownames = "feature")
  
  names(df)[names(df) == "V1"] <- "value"
  
  return(df)
  
}

#correlation function
corr_simple <- function(data=df,sig=0.5){
  #convert data to numeric in order to run correlations
  #convert to factor first to keep the integrity of the data - each value will become a number rather than turn into NA
  df_cor <- data %>% mutate_if(is.character, as.factor)
  df_cor <- df_cor %>% mutate_if(is.factor, as.numeric)
  #run a correlation and drop the insignificant ones
  corr <- cor(df_cor)
  #prepare to drop duplicates and correlations of 1     
  corr[lower.tri(corr,diag=TRUE)] <- NA 
  #drop perfect correlations
  corr[corr == 1] <- NA 
  #turn into a 3-column table
  corr <- as.data.frame(as.table(corr))
  #remove the NA values from above 
  corr <- na.omit(corr) 
  #select significant values  
  
  if(nrow(subset(corr, abs(Freq) > sig)) > 0){
    corr <- subset(corr, abs(Freq) > sig) 
    #sort by highest correlation
    corr <- corr[order(-abs(corr$Freq)),] 
    #print table
    #print(corr)
    #turn corr back into matrix in order to plot with corrplot
    mtx_corr <- reshape2::acast(corr, Var1~Var2, value.var="Freq")
    
    if(nrow(mtx_corr) == 1){
      corrplot(mtx_corr)
    }else{
      #plot correlations visually
      corrplot(mtx_corr, is.corr=FALSE, tl.col="black", na.label=" ") 
    }
  }
}


# ggplot theme ------------------------------------------------------------



gg_theme <- function(base_size = 12, 
                     dark_text = "#1A242F",
                     flip = FALSE,
                     map = FALSE,
                     legend_position = "right") {
  
  mid_text <-  monochromeR::generate_palette(dark_text, "go_lighter", n_colours = 5)[2]
  light_text <-  monochromeR::generate_palette(dark_text, "go_lighter", n_colours = 5)[3]
  
  if(map == TRUE){
    theme_minimal(base_size = base_size) +
      theme(text = element_text(colour = mid_text, family = "BrandonText", lineheight = 1.1),
            plot.title = element_text(colour = dark_text, family = "EnriquetaSB", size = rel(1.6), margin = margin(12, 0, 8, 0)),
            plot.subtitle = element_text(size = rel(1.1), margin = margin(4, 0, 0, 0)),
            axis.text.y = element_text(colour = light_text, size = rel(0.8)),
            axis.title.y = element_blank(),
            axis.text.x = element_text(colour = mid_text, size = rel(0.8)),
            axis.title.x = element_blank(),
            legend.position = "top",
            legend.justification = 1,
            legend.direction = "horizontal",
            panel.grid = element_line(colour = "#F3F4F5"),
            plot.caption = element_text(size = rel(0.8), margin = margin(8, 0, 0, 0)),
            plot.margin = margin(0.25, 0.25, 0.25, 0.25,"cm"))
  }else{
    theme_minimal(base_size = base_size) +
      theme(text = element_text(colour = mid_text, family = "BrandonText", lineheight = 1.1),
            plot.title = element_text(colour = dark_text, family = "EnriquetaSB", size = rel(1.6), margin = margin(12, 0, 8, 0)),
            plot.subtitle = element_text(size = rel(1.1), margin = margin(4, 0, 0, 0)),
            axis.text.y = element_text(colour = light_text, size = rel(1)),
            axis.title.y = element_text(size = 12, margin = margin(0, 4, 0, 0)),
            axis.text.x = element_text(colour = mid_text, size = rel(1)),
            axis.title.x = element_blank(),
            legend.position = legend_position,
            legend.justification = 1,
            legend.direction = "vertical",
            panel.grid = element_line(colour = "#F3F4F5"),
            plot.caption = element_text(size = rel(0.8), margin = margin(8, 0, 0, 0)),
            plot.margin = margin(0.25, 0.25, 0.25, 0.25,"cm"))  
  }
  
}