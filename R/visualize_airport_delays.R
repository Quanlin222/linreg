# Load necessary packages
library(nycflights13)
library(dplyr)
library(ggplot2)

# Declare global variables and functions to avoid NOTE in R CMD CHECK
globalVariables(c("flights", "arr_delay", "dest", "mean_delay", "airports", "lon", "lat",
                  "%>%", "filter", "group_by", "summarise", "left_join",
                  "ggplot", "aes", "geom_point", "scale_size_continuous", "labs", "theme_minimal"))

# Function to calculate average airport delays
calculate_airport_delays <- function() {
  airport_delays <- flights %>%
    filter(!is.na(arr_delay)) %>%
    group_by(dest) %>%
    summarise(mean_delay = mean(arr_delay, na.rm = TRUE), .groups = 'drop') %>%
    left_join(airports, by = c("dest" = "faa")) %>%
    filter(!is.na(lon) & !is.na(lat))

  return(airport_delays)
}

# Create a visualization function
visualize_airport_delays <- function(airport_delays, point_alpha = 0.5, point_size_range = c(1, 10)) {
  # Create the visualization
  ggplot(data = airport_delays, aes(x = lon, y = lat, size = mean_delay)) +
    geom_point(alpha = point_alpha, color = "blue", shape = 21, fill = "lightblue") +
    scale_size_continuous(range = point_size_range, name = "Mean Arrival Delay (minutes)") +
    labs(title = "Mean Arrival Delays by Airport",
         x = "Longitude",
         y = "Latitude") +
    theme_minimal()
}

# Main function to execute the process
main <- function() {
  airport_delays <- calculate_airport_delays()

  # Print the processed data for debugging, showing the first 20 rows
  print(airport_delays, n = 20)

  # Call the visualization function
  visualize_airport_delays(airport_delays)
}

# Call the main function
main()
