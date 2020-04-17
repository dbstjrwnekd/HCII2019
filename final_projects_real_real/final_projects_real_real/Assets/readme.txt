This project implements a simple "table of contents" scene for loading other webplayers.

To see the example running, visit http://fugugames.com/toc.html

Each menu item is a sphere that expands when you mouse over and loads a specified webplayer when you click on it.
The sphere also "looks at" the mouse pointer.

To customize a menu item, expand, for example, the "Bowl" gameobject,
select it's Sphere child, change the Url field in the Fugu Item script
to that of the webplayer that you want to load. And then adjust the
TextMesh of the Text child to display the appropriate label.

You can also customize the appearance by replacing the Sphere texture
and editing the TextMeshColor.js script to use something besides
Color.blue (or make it a public variable so you can change it in the
inspector).

Once you're ready to build, switch the platform to webplayer in the Build Settings, then build.

The provided font is taken from an old third-person Unity Technologies demo.
The Fugu texture is derived from the Fugu Games logo created by Shane Nakamura Design.

For support, visit http://fugugames.com/facebook or the Fugu Games thread in the Asset Store topic of the Unity forum.
