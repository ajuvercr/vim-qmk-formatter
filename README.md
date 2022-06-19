# vim-qmk-formatter

## Install

```
    Plug 'https://github.com/ajuvercr/vim-qmk-formatter'
```

## Usage

In init.vim
```
nnoremap <leader>vs :lua require"qmk-formatter".format_keymap()<CR>
```

Use `format_keymap` when hovering element inside a keymap layer.

from
```
	[1] = LAYOUT_split_3x5_2(KC_EXLM, KC_AT, KC_HASH, KC_DLR, KC_PERC, KC_CIRC, KC_AMPR, KC_ASTR, KC_MINS, KC_EQL, KC_LSFT, KC_LCBR, KC_LBRC, KC_LPRN, KC_LT, KC_GRV, KC_DEL, KC_SCLN, KC_QUOT, KC_RSFT, KC_TAB, KC_RCBR, KC_RBRC, KC_RPRN, KC_GT, KC_NO, KC_BSLS, KC_PCMM, KC_PDOT, KC_SLSH, KC_BSPC, KC_ENT, KC_TRNS, KC_TRNS),
```

to
```
	[1] = LAYOUT_split_3x5_2(
KC_EXLM, KC_AT  , KC_HASH, KC_DLR , KC_PERC, /*  */ KC_CIRC, KC_AMPR, KC_ASTR, KC_MINS, KC_EQL , 
KC_LSFT, KC_LCBR, KC_LBRC, KC_LPRN, KC_LT  , /*  */ KC_GRV , KC_DEL , KC_SCLN, KC_QUOT, KC_RSFT, 
KC_TAB , KC_RCBR, KC_RBRC, KC_RPRN, KC_GT  , /*  */ KC_NO  , KC_BSLS, KC_PCMM, KC_PDOT, KC_SLSH, 
                           KC_BSPC, KC_ENT , /*  */ KC_TRNS, KC_TRNS                           ),
```


