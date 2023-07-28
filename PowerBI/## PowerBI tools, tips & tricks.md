# PowerBI tools, tips & tricks

### Data Modelling for service
###### Lean models: Seperating report and data model
https://www.youtube.com/watch?v=PlrtBm9YN_Q
0. Creates your pbix with everything
0. publish a copy of your report pbix that has no visuals _(or add a blank, and then hide all pages)_, but all your logic, and remove the "report" it generates from the service page
0. In a 2nd copy of your original pbix, remove all tables from the model
0. In this 2nd copy, load in the ^^ dataset from powerBI service

This ensures you can edit the visual parts of the report without interacting with the database. 

