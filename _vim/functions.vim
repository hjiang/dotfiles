" Diff the current file with the version stored on the disk.
function! DiffWithFileFromDisk()
   let filename=expand('%')
   let diffname = filename.'.fileFromBuffer'
   exec 'saveas! '.diffname
   diffthis
   vsplit
   exec 'edit '.filename
   diffthis
endfunction

