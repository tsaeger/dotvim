if has_key(plugs, 'editorconfig-vim')

let g:EditorConfig_exec_path = '/home/tsaeger/.nix-profile/bin/editorconfig'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

endif
