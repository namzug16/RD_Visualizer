# RB Visualizer

Relational Database Visualizer is a Project(still a demo) inspired by Drawsql and  
it has been made with the sole purpose of learning.
---
## Packages used
- [flutter_hooks](https://github.com/rrousselGit/flutter_hooks)
- [hooks_riverpod](https://github.com/rrousselGit/river_pod)
- [google_fonts](https://github.com/material-foundation/google-fonts-flutter/)

---
## How does it work?
Tables are created and stored in a ChangeNotifier and a Canvas controller  
draws each one of them, dynamically computes the size of the table by measuring  
the size of each TextPainter that belong to the table. The Canvas has features  
such like padding, zooming, and an interactive way of creating relationship between  
tables as the gifs bellow show.  

There are still some important features that are missing in this demo, such as  
knowing what kind of relationship the tables have or from which table the relationship  
starts as well as improving the declaration of the table in the TableManager(left section  
of the app).

---
Capture of the App working

![rdbvisualizer](https://github.com/namzug16/RD_Visualizer/blob/master/assets/rdbvisualizer.PNG)

Table Manager 

![table manager](https://github.com/namzug16/RD_Visualizer/blob/master/assets/tablemanager.PNG)

Features of the Canvas

![canvas features](https://github.com/namzug16/RD_Visualizer/blob/master/assets/rdvisualizer1.gif)
![canvas features](https://github.com/namzug16/RD_Visualizer/blob/master/assets/rdvisualizer2.gif)
