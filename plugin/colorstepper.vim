" ColorStepper.vim
"
" Cycle easily through vim colorschemes.
"
" Original script by scott-268 (2007)
" With modifications by _sc_ (2009) and qualiabyte (2012)

function! LoadColors()
        let g:step_colors = split(globpath(&rtp,"colors/*.vim"),"\n")
endfunction

" return string name of currently applied colorscheme
" http://stackoverflow.com/a/2419692/2295034
function! GetCurrentColor()
        try
            let l:currentColor = g:colors_name
        catch
            let l:currentColor = "default"
        endtry
        return l:currentColor
endfunction

" return number index of next color to source
function! GetNextColor()
        let l:color_index = 0
        let l:count = 0
        let l:currentColor = GetCurrentColor()
        for i in g:step_colors
            if i =~ 'colors.'.l:currentColor.'\.vim'
                let l:color_index = l:count
                break
            endif
            let l:count += 1
        endfor
        return l:color_index
endfunction

function! StepColorBy( count )
        if !exists("g:step_colors")
                call LoadColors()
        endif

        let g:color_step = (GetNextColor() + a:count) % len(g:step_colors)
        silent exe 'so ' . g:step_colors[g:color_step]
        call PrintColorscheme()
endfunction

function! StepColorNext()
        call StepColorBy( 1 )
endfunction

function! StepColorPrev()
        call StepColorBy( -1 )
endfunction

function! PrintColorscheme()
        redraw
        echo g:step_colors[g:color_step]
endfunction

if !hasmapto('<Plug>ColorstepPrev')
    nmap <unique> <F6> <Plug>ColorstepPrev
endif
if !hasmapto('<Plug>ColorstepNext')
    nmap <unique> <F7> <Plug>ColorstepNext
endif
if !hasmapto('<Plug>ColorstepReload')
    nmap <unique> <S-F7> <Plug>ColorstepReload
endif

nmap <unique> <Plug>ColorstepNext :call StepColorNext()<CR>
nmap <unique> <Plug>ColorstepPrev :call StepColorPrev()<CR>
nmap <unique> <Plug>ColorstepReload :call LoadColors()<CR>
