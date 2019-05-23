function init_completedGrid() {
    $("#completedGrid").igGrid({
        dataSource: GLOBAL_COMPLETE_DATA,
        width: "100%",
        virtualization: false,
        autoGenerateColumns: false,
        renderCheckboxes: true,
        primaryKey: "REQID",
        columns:
            [
                {
                    headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "65px", template: "{{if(${REJECT})}}" +
                        "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                },
                { headerText: "Is open in CMS", key: "isOpenInCMS", width: "50px" },
                { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true, readOnly: true },
                { headerText: "MSID", key: "MSID", dataType: "number", width: "75px" },
                { headerText: "PO", key: "PO", dataType: "number", width: "90px" },
                { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "150px" },
                { headerText: "New Spot (If Applicable)", key: "NEWSPOT", dataType: "number", width: "100px", formatter: formatSpotCombo },
                { headerText: "Requester (Task) Comments", key: "TASK", dataType: "string", width: "200px" },
                { headerText: "Requester", key: "REQUESTER", dataType: "string", width: "125px" },
                { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                { headerText: "Due Time ", key: "DUETIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                { headerText: "Assignee", key: "ASSIGNEE", dataType: "string", width: "125px" },
                { headerText: "Assignee Comments", key: "COMMENTS", dataType: "string", width: "200px" },
            ],
        features: [
            {
                name: 'Paging'
            },
            {
                name: 'Resizing'
            },
            {
                name: 'Updating',
                enableAddRow: false,
                editMode: "row",
                enableDeleteRow: false,
                showReadonlyEditors: false,
                enableDataDirtyException: false,
                autoCommit: false,
                columnSettings:
                    [
                        { columnKey: "isOpenInCMS", readOnly: true },
                        { columnKey: "REJECT", readOnly: true },
                        { columnKey: "MSID", readOnly: true },
                        { columnKey: "PO", readOnly: true },
                        { columnKey: "MSID", readOnly: true },
                        { columnKey: "REQID", readOnly: true },
                        { columnKey: "TASK", readOnly: true },
                        { columnKey: "REQUESTER", readOnly: true },
                        { columnKey: "ASSIGNEE", readOnly: true },
                        { columnKey: "TIMEASSIGNED", readOnly: true },
                        { columnKey: "TSTART", readOnly: true },
                        { columnKey: "TEND", readOnly: true },
                        { columnKey: "COMMENTS", readOnly: true },
                        { columnKey: "NEWSPOT", readOnly: true },
                        { columnKey: "TRAILNUM", readOnly: true },
                        { columnKey: "REJECT", readOnly: true },
                        { columnKey: "DUETIME", readOnly: true }
                    ]
            }
        ]

    });// <% --end complete grid-- %>
}