library(tidyverse)
library(rvest)

html <- minimal_html("
  <h1>This is a heading</h1>
  <p id='first'>This is a paragraph</p>
  <p class='important'>This is an important paragraph</p>
")
str(html)

tmp <- html_element(html, "h1")
html_text2(tmp)

html |>
  html_element("h1") |>
  html_text2()

html |>
  html_elements("p") |>
  html_text2()

html |>
  html_elements(".important") |>
  html_text2()

html |>
  html_elements("#first") |>
  html_text2()

html <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <img src='https://cataas.com/cat' width='100' height='200'>
")

html |>
  html_elements("a") |>
  html_attr("href")

# LIVE DEMO -----------------------
url <- "https://www.bruhome.com/v3/buy.asp?p_=buy&id=&district=&propose=&property=&price=&location=&mylist=128&sort=&display=&offset=&bedrooms=&bathrooms=&carpark="
html <- read_html(url)

prices <- html |>
  html_elements(".property-price") |>
  html_text2()

# alternative way
prices <-
  prices |>
  str_remove_all("BND ") |>
  str_remove_all(",") |>
  str_remove_all(" \r") |>
  as.integer()


beds <-
  html |>
  html_elements(".property-bed") |>
  html_text2() |>
  as.integer()

hsp_df <-
  tibble(
    price = prices,
    beds = beds,
    baths = baths,
    location = location
  )


properties <-
  html |>
  html_elements(".property-link") |>
  html_attr("href")


i <- 1
link <- paste0("https://www.bruhome.com/v3/", properties[i])
html <- read_html(link)
out <-
  html |>
  html_elements("p") |>
  html_text2()

res <- c()
for (i in seq_along(properties)) {
  res[i] <- extract_info(i)
}

chat <-
  create_chat("ollama") |>
  add_model("llama3.1") |>
  add_message('Hello how are you? Tell me about Brunei.') |>
  perform_chat()
