<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/AdminPage.Master" CodeBehind="Admin_InspectionLists.aspx.cs" Inherits="TransportationProject.Admin_InspectionLists" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Inspection Lists</h2>
    <h3>View, add, update, and delete inspection lists. </h3>
        <br />
        <br />
    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_INSPECTION_LISTS = [];
        var GLOBAL_LIST_OF_INSPECTIONS = [];
        var GLOBAL_INSPECTIONTYPES = [];
        var GLOBAL_LOADTYPES = [];
        var GLOBAL_SORT_ORDER_DATA = [];
        var FILTERTEXTID = "";
        var FILTERTEXTNAME = "";
        var FILTERTEXT = "";


        
        
        <%-------------------------------------------------------
        PageMethods
        -------------------------------------------------------%>
        function onSuccess_getLoadTypes(value, ctx, methodName) {
            var i;
            var indexForDefault = 0;
            GLOBAL_LOADTYPES = [];
            for (i = 0; i < value.length; i++) {
                GLOBAL_LOADTYPES.push({ "LOADTYPE": value[i][0], "LOADTYPETEXT": value[i][1] });
            }


        $("#cboxLoadTypes").igCombo("option", "dataSource", GLOBAL_LOADTYPES);
        $("#cboxLoadTypes").igCombo("dataBind");

        PageMethods.getInspectionTypes(onSuccess_getInspectionTypes, onFail_getInspectionTypes);
    }
    function onFail_getLoadTypes(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_getLoadTypes");
    }

    function onSuccess_getInspectionTypes(value, ctx, methodName) {
        GLOBAL_INSPECTIONTYPES = [];
        for (i = 0; i < value.length; i++) {
            GLOBAL_INSPECTIONTYPES[i] = { "ID": value[i][0], "INSPECTIONLABEL": value[i][1] };
        }
        $("#cboxInspectionTypes").igCombo("option", "dataSource", GLOBAL_INSPECTIONTYPES);
        $("#cboxInspectionTypes").igCombo("dataBind");

        PageMethods.getInspectionLists(onSuccess_getInspectionLists, onFail_getInspectionLists);        
    }
    function onFail_getInspectionTypes(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Inspections.aspx, onFail_getInspectionTypes");
    }

    function onSuccess_getInspectionLists(value, ctx, methodName) {
        GLOBAL_INSPECTION_LISTS = [];
        for (i = 0; i < value.length; i++) {
            GLOBAL_INSPECTION_LISTS[i] = { "ID": value[i][0], "NAME": value[i][1] };
        }

        $("#cboxInspectionLists").igCombo("option", "dataSource", GLOBAL_INSPECTION_LISTS);
        $("#cboxInspectionLists").igCombo("dataBind");
    }
    function onSuccess_getInspectionListsRebind(value, InspectionListID, methodName) {
        GLOBAL_INSPECTION_LISTS = [];
        for (i = 0; i < value.length; i++) {
            GLOBAL_INSPECTION_LISTS[i] = { "ID": value[i][0], "NAME": value[i][1] };
        }

        $("#cboxInspectionLists").igCombo("option", "dataSource", GLOBAL_INSPECTION_LISTS);
        $("#cboxInspectionLists").igCombo("dataBind");

        $("#cboxInspectionLists").igCombo("value", InspectionListID);


        $("#txtBoxInspectionListName").hide();
        $("#lblInspectionListName").hide();
        $("#btnSaveInspectionList").hide(); 
        $("#btnDeleteInspectionList").prop('disabled', false);
        $("#btnEditInspectionListName").prop('disabled', false);
        
        
        $("#btnCancelInspectionList").hide();

        PageMethods.getListOfInspectionsByInspectionListID(InspectionListID, onSuccess_getListOfInspectionsByInspectionListID, onFail_getListOfInspectionsByInspectionListID);
    }
    function onFail_getInspectionLists(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_getInspectionLists");
    }

    function onSuccess_getListOfInspectionsAndTheirDetails(value, ctx, methodName) {
        GLOBAL_LIST_OF_INSPECTIONS = [];
        for (i = 0; i < value.length; i++) {
            var needsVerifcation;

            if (checkNullOrUndefined(value[i][4]) == true || value[i][4] == false) {
                needsVerifcation = 'No';
            }
            else {
                needsVerifcation = 'Yes';
            }

            GLOBAL_LIST_OF_INSPECTIONS[i] = { "ID": value[i][0], "NAME": value[i][1], "INSPECTIONTYPE": value[i][2], "LOADTYPE": value[i][3], "NEEDSVERFICATION": needsVerifcation };
        }

        $("#cboxListOfInspections").igCombo("option", "dataSource", GLOBAL_LIST_OF_INSPECTIONS);
        $("#cboxListOfInspections").igCombo("dataBind");
        $("#orderGridWrapper").show();
        $("#lblInspectionListName").html("Inspection List Name: ");
    }
    function onFail_getListOfInspectionsAndTheirDetails(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_getListOfInspectionsAndTheirDetails");
    }
    function onSuccess_setNewInspectionListSetNewInspectionAndAssociate(returnArray, ctx, methodName) {
        $("#cboxInspectionLists").data("data-isNewInspectionList", false);
        $("#btnAddInspectionList").prop('disabled', false);
        PageMethods.getInspectionLists(onSuccess_getInspectionListsRebind, onFail_getInspectionLists, returnArray[0]);

        if (returnArray.length > 1 && returnArray[1] == 1) {
            alert("The inspection has been added twice for the 2nd (verification) inspection.");
        }
    }
    function onFail_setNewInspectionListSetNewInspectionAndAssociate(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_setNewInspectionListSetNewInspectionAndAssociate");
    }

    function onSuccess_setNewInspectionToListAndAssociate(needsVerificationTest, InspectionListID, methodName) {
        PageMethods.getListOfInspectionsByInspectionListID(InspectionListID, onSuccess_getListOfInspectionsByInspectionListIDRebind, onFail_getListOfInspectionsByInspectionListID, needsVerificationTest);
    }
    function onFail_setNewInspectionToListAndAssociate(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_setNewInspectionToListAndAssociate");
    }

    function onSuccess_getListOfInspectionsByInspectionListIDRebind(returnData, neededVerificationTest, methodName) {
        GLOBAL_SORT_ORDER_DATA = [];
        for (i = 0; i < returnData.length; i++) {
            var needsVerifcation;

            if (checkNullOrUndefined(returnData[i][5]) == true || returnData[i][5] == false) {
                needsVerifcation = 'No';
            }
            else {
                needsVerifcation = 'Yes';
            }

            GLOBAL_SORT_ORDER_DATA[i] = { "GridRowID": returnData[i][6], "SORTORDER": returnData[i][0], "INSPECTIONID": returnData[i][1], "INSPECTIONNAME": returnData[i][2], "INSPECTIONTYPE": returnData[i][3], "LOADTYPE": returnData[i][4], "NEEDSVERFICATION": needsVerifcation };
        }
        $("#gridInspectionOrder").igGrid("option", "dataSource", GLOBAL_SORT_ORDER_DATA);
        $("#gridInspectionOrder").igGrid("dataBind");

        if (neededVerificationTest) {
            alert("The inspection has been added twice for the 2nd (verification) inspection.");
        }
    }
    function onSuccess_getListOfInspectionsByInspectionListID(returnData, needsVerificationTest, methodName) {
        GLOBAL_SORT_ORDER_DATA = [];
        for (i = 0; i < returnData.length; i++) {
            var needsVerifcation;

            if (checkNullOrUndefined(returnData[i][5]) == true || returnData[i][5] == false) {
                needsVerifcation = 'No';
            }
            else {
                needsVerifcation = 'Yes';
            }

            GLOBAL_SORT_ORDER_DATA[i] = { "GridRowID": returnData[i][6], "SORTORDER": returnData[i][0], "INSPECTIONID": returnData[i][1], "INSPECTIONNAME": returnData[i][2], "INSPECTIONTYPE": returnData[i][3], "LOADTYPE": returnData[i][4], "NEEDSVERFICATION": needsVerifcation };
        }
        $("#gridInspectionOrder").igGrid("option", "dataSource", GLOBAL_SORT_ORDER_DATA);
        $("#gridInspectionOrder").igGrid("dataBind");

        $("#txtBoxInspectionListName").val('');
        $("#lblInspectionName").hide();
        PageMethods.getListOfInspectionsAndTheirDetails(onSuccess_getListOfInspectionsAndTheirDetails, onFail_getListOfInspectionsAndTheirDetails);
    }
    function onFail_getListOfInspectionsByInspectionListID(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_getListOfInspectionsByInspectionListID");
    }

    function onSuccess_disableInspectionList(value, ctx, methodName) {//zxc
        $("#btnDeleteInspectionList").prop('disabled', true); 
        $("#btnAddInspectionList").prop('disabled', false);
        $("#btnEditInspectionListName").prop('disabled', true);

        GLOBAL_SORT_ORDER_DATA = [];
        $("#gridInspectionOrder").igGrid("option", "dataSource", GLOBAL_SORT_ORDER_DATA);
        $("#gridInspectionOrder").igGrid("dataBind");
        $("#orderGridWrapper").hide();

        PageMethods.getInspectionLists(onSuccess_getInspectionLists, onFail_getInspectionLists);
    }
    function onFail_disableInspectionList(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_disableInspectionList");
    }

    function onSuccess_setNewSortOrder(value, newSortOrder, methodName) {
        var counter = $("#gridInspectionOrder").data("data-indexCounter");


        var totalInspectionsOnList = $('#gridInspectionOrder > tbody  > tr').length;
        if (counter == totalInspectionsOnList)
        {
            var inspectionListID = $("#cboxInspectionLists").igCombo("value");
            PageMethods.getInspectionLists(onSuccess_getInspectionListsRebind, onFail_getInspectionLists, inspectionListID);
            $("#gridInspectionOrder").data("data-indexCounter", 1);
        }
        else if (checkNullOrUndefined(counter) == true) {
            $("#gridInspectionOrder").data("data-indexCounter", 2);
        }
        else {
            counter++;
            $("#gridInspectionOrder").data("data-indexCounter", counter);
        }


    }
    function onFail_setNewSortOrder(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_setNewSortOrder");
    }

        function onSuccess_deleteInspectionFromInspectionList(value, ctx, methodName) {
            var inspectListID = $("#cboxInspectionLists").data("data-inspectListID");
            $("#cboxInspectionLists").data("data-isNewInspectionList", "");

            PageMethods.getListOfInspectionsByInspectionListID(inspectListID, onSuccess_getListOfInspectionsByInspectionListID, onFail_getListOfInspectionsByInspectionListID);
        }

        function onSuccess_deleteInspectionFromInspectionListLastInpectionInList(value, ctx, methodName) {
            var inspectListID = $("#cboxInspectionLists").data("data-inspectListID");
            $("#cboxInspectionLists").data("data-isNewInspectionList", "");
            $("#cboxInspectionLists").data("data-inspectListID", "");

            PageMethods.disableInspectionList(inspectListID, onSuccess_disableInspectionList, onFail_disableInspectionList);
        }
        function onFail_deleteInspectionFromInspectionList(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_deleteInspectionFromInspectionList");
        }

        function onSuccess_renameInspectionList(returnValue, inspectionListID, methodName) {
            $("#btnSaveInspectionList").hide();
            $("#btnCancelInspectionList").hide();
            $("#txtBoxInspectionListName").hide();
            $("#lblInspectionListName").hide();

            $("#cboxInspectionLists").data("data-isNewInspectionList", false);
            PageMethods.getInspectionLists(onSuccess_getInspectionListsRebind, onFail_getInspectionLists, inspectionListID);
        }
        function onFail_renameInspectionList(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_InspectionLists.aspx, onFail_renameInspectionList");
        }

    function initSortable() {
            $("#gridInspectionOrder tbody").sortable({
                containment: "parent",
                start: function (evt, ui) {
                    var children = ui.item.children();
                    $("#gridInspectionOrder_headers thead th").each(function (ix, el) {
                        // set the width of each td to its header width
                        $(children[ix]).width($(el).width());
                    });
                },
                stop: function (evt, ui) {
                    var newSortOrder = 1;
                    $('#gridInspectionOrder > tbody  > tr').each(function () {
                        var GridRowID = this.dataset.id;
                        var inspectionID = returnItemFromArray(GLOBAL_SORT_ORDER_DATA, "GridRowID", Number(GridRowID), "INSPECTIONID");
                        var inspectionListID = $("#cboxInspectionLists").igCombo("value");

                        PageMethods.setNewSortOrder(inspectionListID, inspectionID, newSortOrder, GridRowID, onSuccess_setNewSortOrder, onFail_setNewSortOrder, newSortOrder);
                        newSortOrder++;
                    });

                }
            });
            $("#gridInspectionOrder tbody").disableSelection();
    } 
    function onClick_addNewInspectionList() {
        $("#txtBoxInspectionListName").val("");
        $("#btnEditInspectionListName").prop('disabled', true);
        $("#inspectionInfo").show();
        $("#btnSaveInspectionList").show();
        $("#btnCancelInspectionList").show();
        $("#btnDeleteInspectionList").prop('disabled', true);
        $("#btnAddInspectionList").prop('disabled', true);
        $("#lblInspectionName").hide();
        $("#orderGridWrapper").hide();
        $("#txtBoxInspectionListName").show();
        $("#lblInspectionListName").show();
        $("#cboxInspectionLists").data("data-isNewInspectionList", true);
        $("#lblInspectionListName").html("New Inspection List Name: ");
        $("#cboxInspectionLists").igCombo("value", null);        
    }

    function onClick_RenameInspectionList() {
        $("#btnEditInspectionListName").prop('disabled', true);
        $("#inspectionInfo").show();
        $("#btnSaveInspectionList").show();
        $("#btnDeleteInspectionList").prop('disabled', false);
        $("#btnCancelInspectionList").show();
        $("#txtBoxInspectionListName").show();
        $("#lblInspectionListName").show();
        var currentInspectionListName = $("#cboxInspectionLists").igCombo("text");
        $("#txtBoxInspectionListName").val(currentInspectionListName);
        $("#lblInspectionName").hide();
    }

    function doesInspectionListNameExist(inspectionListName) {
        for (var i = 0; i < GLOBAL_INSPECTION_LISTS.length; i++) {
            if (GLOBAL_INSPECTION_LISTS[i].NAME.toLowerCase() == inspectionListName.toLowerCase()) {
                return i;
            }
        }
        return -1;
    }

    function onClick_DeleteInspectionHeaderEdits() {
        var currentInspectionListName = $("#cboxInspectionLists").igCombo("text");

        var c = confirm("Continue deleting request for the inspection list called " + currentInspectionListName + "? Deletion cannot be undone.");

        if (c == true) {
            var currentInspectionListID = $("#cboxInspectionLists").igCombo("value");
            PageMethods.disableInspectionList(currentInspectionListID, onSuccess_disableInspectionList, onFail_disableInspectionList);



            PageMethods.getListOfInspectionsAndTheirDetails(onSuccess_getListOfInspectionsAndTheirDetails, onFail_getListOfInspectionsAndTheirDetails);
        }
        else { return false; }
    }

    function onClick_SaveInspectionList() {
            var isNewInspectionList = $("#cboxInspectionLists").data("data-isNewInspectionList");
            var inspectionListName = $("#txtBoxInspectionListName").val();
            GLOBAL_SORT_ORDER_DATA = [];
            $("#gridInspectionOrder").igGrid("option", "dataSource", GLOBAL_SORT_ORDER_DATA);
            $("#gridInspectionOrder").igGrid("dataBind");

            //first make sure everything is filled out 
            if (checkNullOrUndefined(inspectionListName) == true) {
                alert("Inspection list name can not be blank.");
                return false;
            }

            if (doesInspectionListNameExist(inspectionListName) != -1) {
                alert("Inspection List name already exist.");
                return false;
            }
            else {
                var inspectionListID = $("#cboxInspectionLists").igCombo("value");
                if (isNewInspectionList == true) {
                    alert("Inspection List will be created after the inspection has been added.");
                    PageMethods.getListOfInspectionsAndTheirDetails(onSuccess_getListOfInspectionsAndTheirDetails, onFail_getListOfInspectionsAndTheirDetails);
                }
                else {
                    var inspectionListName = $("#txtBoxInspectionListName").val();
                    PageMethods.renameInspectionList(inspectionListID, inspectionListName, onSuccess_renameInspectionList, onFail_renameInspectionList, inspectionListID);

                }
            }
    }
    function onClick_CancelInspectionListEdit() {
        var inspectionListID = $("#cboxInspectionLists").igCombo("value");
            $("#inspectionInfo").hide(); 
            $("#txtBoxInspectionListName").val("");
            var isNewInspectionList = $("#cboxInspectionLists").data("data-isNewInspectionList");

            if (isNewInspectionList != true) {
                $("#btnEditInspectionListName").prop('disabled', false);
                $("#btnDeleteInspectionList").prop('disabled', false);
            }
            else {
                $("#orderGridWrapper").hide();
                $("#btnAddInspectionList").prop('disabled', false);
            }
            $("#cboxInspectionLists").data("data-isNewInspectionList", "");
    }

    function findLastIndex(dataSource)
    {
        var largestIndex = 0;
        for(var index = 0; index < dataSource.length; index++)
        {
            if (dataSource[index].SORTORDER > largestIndex)
            {
                largestIndex = dataSource[index].SORTORDER;
            }
        }
        return largestIndex;
    }


        
        <%--Formatting for igGrid cells to display igCombo text as opposed to igCombo value--%>
        function formatInspectionNames(val) {
            var i, inspc;
            for (i = 0; i < GLOBAL_LIST_OF_INSPECTIONS.length; i++) {
                inspc = GLOBAL_LIST_OF_INSPECTIONS[i];
                if (inspc.ID == val) {
                    val = inspc.NAME;
                }
            }
            return val;
        }
        
         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>

        //start func
        $(function () {
            PageMethods.getInspectionLists(onSuccess_getInspectionLists, onFail_getInspectionLists);
            $("#cboxInspectionLists").igCombo({
                dataSource: GLOBAL_INSPECTION_LISTS,
                textKey: "NAME",
                valueKey: "ID",
                width: "400px",
                mode: "editable",
                highlightMatchesMode: "contains",
                filteringCondition: "contains",
                autoSelectFirstMatch: false,
                selectionChanged: function (evt, ui) {
                    if (ui.items.length === 0) {
                        $("#txtBoxInspectionListName").val("");
                        $("#orderGridWrapper").hide();
                        $("#btnEditInspectionListName").prop('disabled', true);
                        $("#inspectionInfo").hide();
                        $("#orderGridWrapper").hide();
                        $("#btnDeleteInspectionList").prop('disabled', true);
                        $("#cboxInspectionLists").data("data-isNewInspectionList", false);
                    }                    
                    else {
                        $("#cboxInspectionLists").data("data-inspectListID", ui.items[0].data.ID);
                        $("#btnEditInspectionListName").prop('disabled', false);
                        $("#inspectionInfo").show();
                        $("#lblInspectionName").show();
                        $("#btnSaveInspectionList").hide();
                        $("#btnDeleteInspectionList").prop('disabled', false);
                        $("#btnCancelInspectionList").hide();
                        $("#txtBoxInspectionListName").hide();
                        $("#lblInspectionListName").hide();
                        $("#orderGridWrapper").show();
                        $("#cboxInspectionLists").data("data-isNewInspectionList", false);
                        $("#lblInspectionName").text("Inspection List Name: " + ui.items[0].data.NAME);
                        PageMethods.getListOfInspectionsByInspectionListID(ui.items[0].data.ID, onSuccess_getListOfInspectionsByInspectionListID, onFail_getListOfInspectionsByInspectionListID);
                        //PageMethods.getProductsGridData(ui.items[0].data.ID, onSuccess_getProductsGridData, onFail_getProductsGridData);
                    }


                }
            });


            $("#gridInspectionOrder").igGrid({
                dataSource: null,
                width: "99%",
                virtualization: false,
                autoGenerateColumns: true,
                autofitLastColumn: true,
                renderCheckboxes: false,
                primaryKey: "GridRowID",
                columns:
                    [ 
                        { headerText: " ", key: "GridRowID", dataType: "number", hidden: true, width: "0px" },
                        { headerText: "Sort Order", key: "SORTORDER", dataType: "number", width: "60px" },
                        { headerText: " ", key: "INSPECTIONID", dataType: "number", hidden: true, width: "0px" },
                        { headerText: "Inspection Name", key: "INSPECTIONNAME", dataType: "string", formatter: formatInspectionNames, width: "400px" },
                        { headerText: "Inspection Type", key: "INSPECTIONTYPE", dataType: "string", width: "400px" },
                        { headerText: "Load Type", key: "LOADTYPE", dataType: "string", width: "400px" },
                        { headerText: "Requires 2nd User Verification", key: "NEEDSVERFICATION", dataType: "string", width: "400px" }

                    ],
                features:
                    [
                        {
                            name: 'Updating',
                            enableAddRow: true,
                            enableDeleteRow: true,
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            //editCellEnding: function (evt, ui) {
                            //    var indexOfInspection = $("#gridInspectionOrder").data("indexOfInspection");

                            //    $("#gridInspectionOrder").igGridUpdating("setCellValue", ui.rowID, 'PRODUCTID', productID);



                            //},
                            rowDeleting: function (evt, ui) {
                                var inspectListID = $("#cboxInspectionLists").data("data-inspectListID"); 
                                var inspectionHeaderID = $("#gridInspectionOrder").igGrid("getCellValue", ui.rowID, "INSPECTIONID");
                                var sortOrder = $("#gridInspectionOrder").igGrid("getCellValue", ui.rowID, "SORTORDER");
                                var needsVerication = $("#gridInspectionOrder").igGrid("getCellValue", ui.rowID, "NEEDSVERFICATION");
                                var rowCount = $("#gridInspectionOrder").igGrid("rows").length;

                                if ((rowCount == 1) || (rowCount == 2 && needsVerication == 'Yes'))
                                {
                                    var c = confirm("Deleting this inspection from the list will delete the whole list. This can not be undone. Would you like to continue?");
                                    if (c == true) {
                                        PageMethods.deleteInspectionFromInspectionList(inspectListID, inspectionHeaderID, sortOrder, onSuccess_deleteInspectionFromInspectionListLastInpectionInList, onFail_deleteInspectionFromInspectionList, inspectListID);
                                    }
                                }
                                else {
                                    PageMethods.deleteInspectionFromInspectionList(inspectListID, inspectionHeaderID, sortOrder, onSuccess_deleteInspectionFromInspectionList, onFail_deleteInspectionFromInspectionList, inspectListID);
                                }

                            },
                            editCellStarting: function (evt, ui) {
                                if (ui.columnKey == "LOADTYPE" || ui.columnKey === "INSPECTIONTYPE" || ui.columnKey === "NEEDSVERFICATION") { //disable columns
                                    return false;
                                }
                            },
                            editRowEnding: function (evt, ui) {
                                var origEvent = evt.originalEvent;
                                if (typeof origEvent === "undefined") {
                                    ui.keepEditing = true;
                                    return false;
                                }
                                if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {

                                    var isNewInspectionList = $("#cboxInspectionLists").data("data-isNewInspectionList");

                                    if (isNewInspectionList == true) {
                                        var inspectionListName = $("#txtBoxInspectionListName").val();
                                        PageMethods.setNewInspectionListSetNewInspectionAndAssociate(inspectionListName, ui.values.INSPECTIONNAME,
                                                                        onSuccess_setNewInspectionListSetNewInspectionAndAssociate, onFail_setNewInspectionListSetNewInspectionAndAssociate);
                                    }
                                    else {
                                        var inspectionListID = $("#cboxInspectionLists").igCombo("value");
                                        var inspectionHeaderID = ui.values.INSPECTIONNAME;
                                        var lastIndexPlus1 = (findLastIndex(GLOBAL_SORT_ORDER_DATA) + 1);

                                        for (var i = 0; i < GLOBAL_SORT_ORDER_DATA.length; i++) {
                                            if (inspectionHeaderID == GLOBAL_SORT_ORDER_DATA[i].INSPECTIONID) {
                                                alert("You cannot add the same inspection twice to an inspection list.")
                                                return false;
                                            }
                                        }
                                        PageMethods.setNewInspectionToListAndAssociate(inspectionListID, inspectionHeaderID, lastIndexPlus1,
                                                                        onSuccess_setNewInspectionToListAndAssociate, onFail_setNewInspectionToListAndAssociate, inspectionListID);
                                    }
                                }
                                else {
                                    //ui.keepEditing = true;
                                    return false;
                                }

                            },
                            editRowStarting: function (evt, ui) {
                                //alert(ui.columnKey.INSPECTIONNAME);
                            },
                            columnSettings:
                                [
                                { columnKey: "SORTORDER", readOnly: true },
                                    {
                                        columnKey: "INSPECTIONTYPE",
                                        editorType: "text",
                                        //readOnly: true,
                                        editorOptions: {
                                            mode: "readonly",
                                            id: "txtInspectionTypes",
                                        }
                                    },

                                    {
                                        columnKey: "LOADTYPE",
                                        editorType: "text",
                                        //readOnly: true,
                                        editorOptions: {
                                            mode: "readonly",
                                            id: "txtLoadTypes",
                                        }
                                    },
                                    {
                                        columnKey: "INSPECTIONNAME",
                                        editorType: "combo",
                                        required: true,
                                        editorOptions: {
                                            mode: "editable",
                                            enableClearButton: false,
                                            dataSource: GLOBAL_LIST_OF_INSPECTIONS,
                                            id: "cboxListOfInspections",
                                            textKey: "NAME",
                                            valueKey: "ID",
                                            dropDownOpening: function (evt, ui) {
                                                $("#cboxListOfInspections").igCombo("option", "dataSource", GLOBAL_LIST_OF_INSPECTIONS);
                                                $("#cboxListOfInspections").igCombo("dataBind");

                                            },
                                            selectionChanged: function (evt, ui) {//asd
                                                var inspectionListID = ui.items[0].data.ID;

                                                //dsa
                                                $("#txtInspectionTypes").igEditor("text", ui.items[0].data.INSPECTIONTYPE);
                                                $("#txtLoadTypes").igEditor("text", ui.items[0].data.LOADTYPE);
                                                $("#txtNeedsVerfication").igEditor("text", ui.items[0].data.NEEDSVERFICATION);


                                                //var indexOfInspection = doesInspectionListNameExist(inspectionListName);
                                                //$("#gridInspectionOrder").data("indexOfInspection", indexOfInspection);

                                                //GLOBAL_LIST_OF_INSPECTIONS[indexOfInspection]



                                            }
                                        }
                                    },
                                    {
                                        columnKey: "NEEDSVERFICATION",
                                        editorType: "text",
                                        //readOnly: true,
                                        editorOptions: {
                                            mode: "readonly",
                                            id: "txtNeedsVerfication",
                                        }
                                    }
                                ]
                        }
                    ],
                rowsRendered: function (evt, ui) {
                    // initialize sortable on the grid tbody
                    initSortable();
                }

            }); <%--end of $("#gridInspectionOrder").igGrid({--%>




            
            $("#orderGridWrapper").hide();
            $("#btnEditInspectionListName").prop('disabled', true);
            $("#inspectionInfo").hide();
            $("#btnDeleteInspectionList").prop('disabled', true);

        });

    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
        
      <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div><h2>Create a new inspection list</h2><button type="button" id="btnAddInspectionList" onclick='onClick_addNewInspectionList()'>Add New Inspection List</button></div>
        <h2>Or select an inspection list from the drop down list to edit</h2>
        <table>
        <tr><td>
        <input id="cboxInspectionLists" /></td>
        <td></td>
        <td><button type="button" id="btnEditInspectionListName" onclick='onClick_RenameInspectionList()'>Rename Inspection List</button></td>
        <td><button type="button" id="btnDeleteInspectionList" onclick='onClick_DeleteInspectionHeaderEdits()'>Delete Inspection List</button>
        </td></tr>
        </table>
    <div id="inspectionInfo">
        <br />
        <%--<h2 id ="lblInspectionName">Inspection List Name: </h2>--%>
        <br />
        <table><tr><td><label id="lblInspectionListName">Inspection List Name:</label></td><td><input type="text" id="txtBoxInspectionListName" style="width: 250px; height: 30px;" maxlength="100" \ /></td>
            <td><button type="button" id="btnSaveInspectionList" onclick='onClick_SaveInspectionList()'>Save Inspection List Name</button></td>
            <td><button type="button" id="btnCancelInspectionList" onclick='onClick_CancelInspectionListEdit()'>Cancel</button></td></tr></table>
    </div>

    <div id="orderGridWrapper">
        <h2>List of Inspections</h2>
    <br />
        <table id="gridInspectionOrder" class="scrollGridClass"></table>
    </div>

    <br />
    <br />


</asp:Content>
