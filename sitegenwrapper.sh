# -*- mode: shell-script -*-

# Verify that the SITES_HOME directory exists
sitegen_verify_sites_home () {
    if [ ! -d "$SITES_HOME" ]
    then
        echo "ERROR: Sitegen sites directory '$SITES_HOME' does not exist.  Create it or set SITES_HOME to an existing directory." >&2
        return 1
    fi
    return 0
}

# Verify that the requested site exists
sitegen_verify_site () {
    typeset project="$1"
    if [ ! -d "$SITES_HOME/$project" ]
    then
       echo "ERROR: Project '$project' does not exist." >&2
       return 1
    fi
    return 0
}

# List of available sites.
sitegen_find_sites () {
    sitegen_verify_sites_home || return 1
    ( cd "$SITES_HOME"; for f in */*/.sitegen; do echo $f; done ) 2>/dev/null | \sed 's|/\.sitegen||' | \sed 's|\*/\*||' | \sort
}

# Show site info
sitegen_showsite () {
    typeset site=$1
    echo -n $site | \sed 's|/|:|'
    echo -n ' ['
    cat $SITES_HOME/$site/.sitegen
    echo ']'
}

lssites () {
    sitegen_verify_sites_home || return 1

    for site in $(sitegen_find_sites)
    do
        sitegen_showsite "$site"
    done
}

# Change dir to site dir
cdsite () {
    typeset project="$1"
    sitegen_verify_sites_home || return 1
    sitegen_verify_site $project || return 1
    cd $SITES_HOME/$project
}

envsite () {
    typeset project="$1"
    sitegen_verify_sites_home || return 1
    sitegen_verify_site $project || return 1

    activate=$SITES_HOME/$project/.virtualenv/bin/activate
    if [ ! -f "$activate" ]
    then
        echo "ERROR: Project '$SITES_HOME/$project' does not contain an activate script." >&2
        return 1
    fi

    type deactivate >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        deactivate
        unset -f deactivate >/dev/null 2>&1
    fi
    
    source "$activate"
}

if [ -n "$BASH" ] ; then
    _sites ()
    {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=( $(compgen -W "`sitegen_find_sites`" -- ${cur}) )
    }

    complete -o default -o nospace -F _sites cdsite
    complete -o default -o nospace -F _sites envsite
fi
