# arpeggio

__Define chords (simultaneously pressed keys) for speedy typing!__

This plugin is heavily inspired by [kana/vim-arpeggio](https://github.com/kana/vim-arpeggio).

## Usage

Put the chord definitions in the `arpeggio.chords` section of your `config.cson`:

```cson
"*":
  arpeggio:
    chords:
      fun: 'function'
```

Now, whenever you press <kbd>f</kbd>, <kbd>u</kbd>, <kbd>n</kbd> at the same time, you type the word __function__.


### Running a command

```cson
      sd:
        command: "editor:delete-to-beginning-of-word"
      kl:
        command: "editor:delete-to-beginning-of-word"
```

If you press the chord <kbd>sd</kbd> or <kbd>kl</kbd>, it will remove the last typed word.
I use it when I want to delete a lot of text without moving my hands away from the home row.


### Inserting a snippet

```cson
      con:
        snippet: 'console.log($1)'
```

If you press the chord <kbd>con</kbd>, then `console.log()` will be typed,
with the cursor between the parentheses.

__Note:__ The snippets package must be activated in order for this feature to work.


## Use Cases

### Quickly type some hard-to-type unicode characters

```cson
      kaw: "川"
      kuc: "口"
      del: "∆"
      pri: "ʹ"
```

This allows you to type code like this very easily:

```js
var ∆x = xʹ - x
```


### For quickly typing common words

```cson
      the: "the"
```

If you press <kbd>t</kbd>, <kbd>h</kbd>, <kbd>e</kbd> at the same time,
you will always get the word __the__, no matter in which order you pressed these keys.


### Quickly insert a brackets block

```cson
      "{}":
        snippet: '''
          {
            $1
          }
        '''
```

If you press <kbd>{</kbd> and <kbd>}</kbd> at the same time,
you will get an empty curly braces block, with the cursor positioned at the `$1` placeholder.


### Share your chords [in the wiki!](https://github.com/dtinth/atom-arpeggio/wiki)


## Configuration Reference

```cson
"*":
  arpeggio:
    chords:
      <trigger>: <expansion>
```

- The `trigger` is a string of keys that is used to trigger.
- The `expansion` is an expansion object or a string for simple text expansion.


### Expansion Object

An expansion is a text with the following keys:

| Key | Type | Description |
| --- | ---- | ----------- |
| `text` | Action | The text to expand to. |
| `snippet` | Action | The snippet source to expand to. |
| `command` | Action | The command to invoke. |
| `timeout` | Option | The timeout in milliseconds. The keys in this particular chord must be pressed successively within the specified timeout in order for the chord to be triggered. This is useful when the chord is often accidentally triggered during normal typing. |
