# RB Visualizer

Relational Database Visualizer is a Project(still a demo) inspired in Drawsql and  
has been made with the sole purpose of learning.
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


## License
MIT License

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



