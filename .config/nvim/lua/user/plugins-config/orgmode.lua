require("orgmode").setup_ts_grammar()

require("orgmode").setup({
    org_agenda_files = { '~/orgs/*' },
    org_default_notes_file = '~/orgs/refile.org',
})
