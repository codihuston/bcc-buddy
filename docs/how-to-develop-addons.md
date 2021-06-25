# How To Develop Addons

# Testing In-Game

Once your addon files are in the `Wow Addons` directory, you can boot the game,
log in, and test your changes.

As soon as you log in, it's advisable to enable logging:

```
/console scriptErrors 1
```

You should disable logging when you are done developing:

```
/console scriptErrors 0
```

Running a function defined in your Addon's Lua scripts in game:

```
/run MyFunctionName()
```

If you make changes to the contents of a script, you can simply reload
the UI in order to test your changes:

```
/reload
```

Running a script in game without reloading. This can be helpful when testing
outputs of a simple script.
```
/run RunScript('<Paste Your Script Here>')
```

> Note: reloading the UI will not suffice if you update the `.toc` or
> rename any of your files that you're testing. You will have to relaunch the
> game in order for those changes to take effect.

