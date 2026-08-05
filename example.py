import mechanicalsoup

# Connect to our course website
browser = mechanicalsoup.StatefulBrowser(user_agent='MechanicalSoup')
browser.open("http://www.se.rit.edu/~swen-331")

# Find all links using the CSS selector
for link in browser.page.select('a'):
    print(link.text)