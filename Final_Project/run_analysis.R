preprocessing <- function(dir, tfiles, out = paste("main.", tfiles, sep = "")){
    
    # Uploading training and testing data to R
    
    path = paste(dir,"/", tfiles, sep = "")
    
    for(filename in dir(path, pattern = ".txt", full.names = T)){
        data <- read.table(filename)
        dataname <- strsplit(filename, "/")[[1]][3]
        assign(dataname, data)
    }
    
    vnames <- read.table(paste(dir,"/features.txt", sep = ""))
    act <- as.character(read.table(paste(dir,"/activity_labels.txt", sep = ""))[,2])
    
    
    # Creating a list containig the file names into function environment
    
    nfiles <- ls(pattern=".txt")
    ndata <- NULL
    for(i in 1:length(nfiles)) ndata[i] <- list(as.name(nfiles[i]))
    order.ndata <- c(ndata[[3]], ndata[[1]], ndata[[2]])
    
    
    # Merging Activity and Subject labels with all measurement records
    
    all.data <- do.call(cbind, order.ndata)
    names(all.data) <- c("Activity", "Subject", as.character(vnames[,2]))
    all.data$Activity <- as.character(all.data$Activity)

    
    # Setting Activity related to each label of it
    
    activities <- all.data$Activity 
    for (i in 1:length(activities)){
        all.data$Activity[i] <- switch(activities[i],
            "1" = act[1], "2" = act[2], "3" = act[3],
            "4" = act[4], "5" = act[5], "6" = act[6]
        )
    }
    
    # Saving training and testing data into R workspace
    
    assign(out, all.data, envir = globalenv())
}


tidy <- function(){
    
    # Merge testing and training data
    
    for (i in c("test", "train")) preprocessing("UCI HAR Dataset", i)
    main <- rbind(main.train, main.test)
    main <- main[order(main$Activity, decreasing=F),]
    nmain <- names(main)
    mean.std <- NULL

    
    # Getting subset containing only mean and standar deviation
    
    for (i in 3:length(nmain)){
        measure <- strsplit(nmain[i],"-")[[1]][2]
        sep <- any(
                   !is.na(measure) && measure == "mean()",
                   !is.na(measure) && measure == "std()"
                  )
        if(sep){
            mean.std[i] <- nmain[i]
        }
        mean.std <- mean.std[!is.na(mean.std)]
        main.disp <- main[c("Subject", "Activity", mean.std)]
    }

    # Aggregate data set by Subject and Activity
    
    final <- aggregate(. ~ Subject * Activity, data = main.disp, FUN = mean)
    names(final)[1:2] <- c("Subject", "Activity")
    assign("average", final, envir = globalenv())

    
    # Saving final data set to a .txt file
    
    write.table(final, "average.txt", sep = ",", row.names = F)
}

tidy()
