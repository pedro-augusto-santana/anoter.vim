*** anoter - note taking plugin ***
This is a personal plugin, so it is adjusted to my needs and it is most of all
a programming (and a vim) exercise
But by all means feel free to use it and if any issues arise during your usage
don't hesitate to open an issue so I can look into making it work for you as well

*** Features ***
All this plugin does is change a few markdown syntax highlighting, add some keybindings
and add automatic text manipulation à la [orgmode](https://orgmode.org), like with TODO
lists
Simple zettelkasten-like not taking structure, but free-form enough that it is not
mandatory (maybe a more strict zettelkasten feature-set will be implemented in the future)

*** Planned features ***
- org-like folding of markdown headers (#+)
- usage of vimgrep + quickfix to find all TODO items
- vimwiki-like tabs and index commands
- automatic item add for lists
- syntax highlighting for checklists: [] && [x] && [~]
- make a neural network to solve P vs NP (may take a week or 2 more than planned)

*** Not planned features ***
- HTML/PDF exporting
- Paragraph handling (like orgmode)

*** Keybindings ***
=== global ===
<leader>Nz  : Creates a new zettelkasten note in g:notes_dir/zettel (make sure it exists beforehand)
<leader>ni  : Goes to g:notes_dir/index.md
<C-Space>   : Cycle through TODO states and checklists ([ ] -> [x])
<leader>wd  : Mark task as WONTDO (cycle through WONTDO states) and checklists ([ ] -> [~])

=== markdown only ===
<Tab>   : Goes to next link
<S-tab> : Goes to previous link
<Enter> : Follow link

*** License ***
Licensed under MIT License or do whatever just mention I made this
