This project is for educational purposes and should not be considered production ready.

[Stylus][1] is used instead of SASS but they're roughly equivalent.

Laptop Installation
========================
1. Install [node](http://nodejs.org)
2. Install [grunt](http://gruntjs.com/) - `sudo npm install -g grunt-cli`
3. git clone ssh://git.amazon.com:2222/pkg/AgileUI
4. Run `npm install` in project root.
5. Run `grunt --force`. This starts a simple server, watches all files in `src`, and automatically compiles them to `build` when changes are made.
6. Visit <http://localhost:8001> (you can change the port number in Gruntfile.js)



[1]:http://learnboost.github.io/stylus/