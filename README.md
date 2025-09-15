# Windows Drive Search Bot (Beta)
## Overview

A Godot‑based desktop search utility that indexes all local and network drives on the user's computer.

The beta release provides fast file‑name search; the upcoming full version will integrate a virtual assistant for a bit more personality.

## Features

- Full‑drive indexing – scans every mounted drive, including SMB/NFS network shares.
- On Demand updates - index when you want, stores index file locally.
- Lightweight UI – Godot 4.x UI with instant results as you type.

## Known issues

- Indexing takes a lot of time and locks up the program until it's done.

## Installation

### Pre Compiled

Download and run the exe from Releases

### Build from source

#### Clone the repository

~~~
git clone https://github.com/algebuckina/WindowsDriveSearchBot.git
cd godot-searchbot
~~~

#### Open in Godot

- Launch Godot 4.x.
- Click Import, select project.godot, and open.

#### Export (optional)

- Use Godot's export templates for your target OS.
- Follow the standard export steps in the editor.

