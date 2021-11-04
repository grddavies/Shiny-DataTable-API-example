Shiny.addCustomMessageHandler("instFilter", function(args) {
 let table = $(args.tablelocator).DataTable();
 table.column(6).search(args.regex, regex=true).draw();
});

Shiny.addCustomMessageHandler("speciesFilter", function(args) {
 let table = $(args.tablelocator).DataTable();
 table.column(5).search(args.regex, regex=true).draw();
});
