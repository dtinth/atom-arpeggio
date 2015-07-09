# arpeggio

Define chords for speedy typing! Inspired by [kana/vim-arpeggio](https://github.com/kana/vim-arpeggio).

## Usage

Put the chord definitions in the `arpeggio.chords` section of your `config.cson`:

```cson
"*":
  arpeggio:
    chords:
      fun: 'function'
```

Now, whenever you press <kbd>f</kbd>, <kbd>u</kbd>, <kbd>n</kbd> at the same time, you type the word __function__.


## Use Cases

### Quickly type some hard-to-type unicode characters

```cson
      kaw: "川"
      kuc: "口"
```

### For quickly typing common words

```cson
      the: "the"
```

If you press <kbd>t</kbd>, <kbd>h</kbd>, <kbd>e</kbd> at the same time,
you will always get the word __the__, no matter in which order you pressed these keys.

### Share your chords [in the wiki!](https://github.com/dtinth/atom-arpeggio/wiki)
