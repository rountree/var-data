dirs = c(   "./poll/", "./sample/10ms/", "./sample/100ms/", "./sample/1s/", "./sample/10s/" )

Lfiles = c( "longitudinal_0_FIXED_FUNCTION_COUNTERS_READ.out",
            "longitudinal_1_ENERGY_COUNTERS_READ.out" )

Pfiles = c( "poll_0_aperf_0x611.out",
            "poll_0_daperf_0x611.out",
            "poll_0_mperf_0x611.out",
            "poll_0_dmperf_0x611.out",
            "poll_0_tsc_0x611.out",
            "poll_0_dtsc_0x611.out",
            "poll_0_therm_0x611.out",
            "poll_0_ptherm_0x611.out",
            "poll_0_tag_0x611.out",
            "poll_0_msrdata_0x611.out",
            "poll_0_dmsrdata_0x611.out" )

intervals_ms = c( 0, 10, 100, 1000, 10000 )


load_data <- function() {

    d <<- NULL
    l <<- NULL

    for( dir_idx in 1:length(dirs) ){

        # Polling data
        temp <- NULL
        temp <- read.table( paste( dirs[dir_idx], Pfiles[1], sep="" ), header=T )
        for ( file_idx in 2:(length(Pfiles)) ){
            temp <- cbind( temp, read.table( paste( dirs[dir_idx], Pfiles[file_idx], sep="" ), header=T ) )
        }
        temp$ms <- intervals_ms[ dir_idx ]
        d <<- rbind( d, temp )


        # Longitudinal data
        temp <- read.table( paste( dirs[dir_idx], Lfiles[1], sep="" ), header=T )
        temp <- rbind( temp, read.table( paste( dirs[dir_idx], Lfiles[2], sep="" ), header=T ) )
        temp$ms <- intervals_ms[ dir_idx ]
        l <<- rbind( l, temp )

    }
    d$dJ <<- d$dmsrdata / (2^15)
    d$dS <<- d$dtsc     / 2400000000
    d$dW <<- d$dJ       / d$dS
}
