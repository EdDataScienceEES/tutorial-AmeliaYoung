# Coding Club Data Visualisation Tutorial 3

## The aim of this tutorial is to quantify species' geographical range and visualise the impact of the Australian 'Black Summer' on invertebrates.

You can check out the full tutorial online here https://eddatascienceees.github.io/tutorial-AmeliaYoung/


----

Following on from the <a href="https://ourcodingclub.github.io/tutorials/data-vis-2/" target="_blank">Data Visualisation: Part 2</a> tutorial, we will now be exploring alternative ways to visualise data through _concave hull maps_, and _hexagonal grid maps._
The possibilities for data visualisation are limitless, and this tutorial aims to equip you with two more powerful techniques for your toolkit!

<a name="section1"></a>

### 1. Introduction
The 2019–2020 Australian wildfires, known as the "Black Summer" fires, inflicted widespread devastation on natural habitats and native biodiversity. This tutorial will use a dataset from [CSIRO, Data Access Portal](https://data.csiro.au/collection/csiro:56679), to visualise Invertebrates' spatial distribution (concave hull maps), and geographical spread (hexagonal grid maps), before and after the Black Summer fires. The impact on invertebrates, (insects, molluscs, spiders), is often overlooked after natural disasters. Which makes open access diversity data even more essential in understanding potential trends, so scientists and conservationists can identify which species or regions face the most significant threats, helping to prioritise population growth. 

_Concave Hull Maps are minimum bounding polygons that tightly enclose points. We aim to create compact polygons around species' occurrence points, revealing insights into their spatial distribution across the landscape_


<a name="prerequisites"></a>

### 1.1 Prerequisites
Whilst this tutorial is of basic to intermediate difficulty, we recommend that learners go back and first complete the <a href="https://ourcodingclub.github.io/tutorials/datavis/" target="_blank">Data Visualisation: Part 1</a> tutorial and <a href="https://ourcodingclub.github.io/tutorials/data-vis-2/" target="_blank">Data Visualisation: Part 2</a> tutorial.

To get the most out of this tutorial, you should have a basic understanding of the following:


- **Data manipulation with `dplyr`:** Transforming, cleaning, and filtering data.  

- **Data visualisation with `ggplot2`:** Creating plots to explore and communicate data patterns.  

----

#### If you have any questions about completing this tutorial, please contact us on ourcodingclub@gmail.com

Check out https://ourcodingclub.github.io/workshop/ to learn how you can get involved!

#### <a href="https://www.surveymonkey.co.uk/r/X7VHQ6S">We would love to hear your feedback on the tutorial, whether you did it at a Coding Club workshop or online!</a>











[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/6eRt7-90)
# tutorial-instructions
## Instructions for Tutorial Assignment

The key final assignment for the Data Science course is to create your own tutorial. Your tutorial has to communicate a specific quantitative skill - you can choose the level at which you pitch your tutorial and how advanced or introductory it is. You can create "part 2" tutorials where "part 1" is an existing Coding Club tutorial.

You are encouraged to add your peers to your tutorial development repositories so that you can exchange feedback - remember that the best way to check if your tutorial makes sense is to have someone that is not you go through it.

__Note that the deadline for this challenge is 12pm on 28th November 2024. Submission is via GitHub like with previous challenges, but you have to also submit a pdf version of your tutorial via Turnitin before 12pm on 28th November 2024. Your submission on GitHub will represent a repository that is also a website (the tutorial on making tutorials below explains how to turn a GitHub repo into a website) and you can just save a pdf of your website using `File/Export as pdf` when you've opened your repository website, you don't need to be separately generating a pdf through code unless you want to.__

__Marking criteria:__

•	Topic – A relevant topic and content that is appropriate for a Coding Club tutorial and relevant to the field of data science, plus appropriate for learners at a particular skill level - at least 4th year Environmental / Ecological science student. - 25%

•	Structure – Clear and logical structure to the tutorial that is easy to navigate with clear instructions. Clear, concrete and measurable learning objectives (i.e., people can tell exactly what they are learning and when they have achieved each learning objective). - 25%

•	Reproducibility – People can do the tutorial on their own, without assistance and without needing to pay for extra software, the code works and people can easily access any data needed to complete the tutorial. - 25%

•	Creativity – A well-illustrated, professionally designed tutorial with appropriate figures and diagrams. A creative and engaging approach to teaching the learning objectives. - 25%

__Useful links:__
- https://ourcodingclub.github.io/tutorials/tutorials/ - Coding Club tutorial on how to make tutorials
- https://ourcodingclub.github.io/tutorials/ - all the other Coding Club tutorials
- https://github.com/ourcodingclub/ourcodingclub.github.io - the repository behind the Coding Club website - here you can see the Markdown code for how the tutorials were formatted
- https://rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf - markdown cheatsheet

__Absolute top of the class examples of tutorials made by DS students:__
- https://ourcodingclub.github.io/tutorials/data-manip-creative-dplyr/ - Advanced data manipulation: Creative use of diverse dplyr functions by Jakub Wieczorkowski
- https://ourcodingclub.github.io/tutorials/data-scaling/ - Transforming and scaling data by Matus Seci
- https://ourcodingclub.github.io/tutorials/anova/ - ANOVA from A to (XY)Z by Erica Zaja
- https://ourcodingclub.github.io/tutorials/spatial-vector-sf/ - Geospatial vector data in R with sf by Boyan Karabaliev
- https://eddatascienceees.github.io/tutorial-assignment-beverlytan/ - Creating a repository with a clear structure by Beverly Tan
- https://ourcodingclub.github.io/tutorials/spatial/ - Intro to Spatial Analysis in R by Maude Grenier

All the other useful links we have shared with previous challenges and from the course reading - think of the tutorials you have done in the past - what did you like about those tutorials, what didn't work so well and could be improved.
