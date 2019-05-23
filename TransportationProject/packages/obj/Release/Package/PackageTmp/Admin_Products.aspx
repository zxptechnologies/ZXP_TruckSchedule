<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_Products.aspx.cs" Inherits="TransportationProject.Admin_Products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<script>

<%-------------------------------------------------------
//GLOBALS
-------------------------------------------------------%>
    var GLOBAL_TANK_OPTIONS = [];
    var GLOBAL_SPOT_OPTIONS = [];
    var GLOBAL_PATTERN_OPTIONS = [];
    var GLOBAL_INSPECTIONLIST_OPTIONS = [];
    var GLOBAL_ASSOCIATION


    <%-------------------------------------------------------
    //Pagemethod functions
-------------------------------------------------------%>

    //ProductID_CMS, ProductName_CMS, TankData, InspectionListsData, PatternData, SpotData
    function onSuccess_getProductsAndAssociationsGridData(value, ctx, methodName) {
        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "PRODID": value[i][0], "PRODNAME": value[i][1], "TANKS": value[i][2], "INSPECTIONS": value[i][3], "PATTERNS": value[i][4], "SPOTS": value[i][5] };
        }
        $("#GridProductAssociations").igGrid("option", "dataSource", gridData);
        $("#GridProductAssociations").igGrid("dataBind");
    }
    function onSuccess_getProductsAndAssociationsGridDataRebind(value, newProduct, methodName) {
        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "PRODID": value[i][0], "PRODNAME": value[i][1], "TANKS": value[i][2], "INSPECTIONS": value[i][3], "PATTERNS": value[i][4], "SPOTS": value[i][5] };
        }
        $("#GridProductAssociations").igGrid("option", "dataSource", gridData);
        $("#GridProductAssociations").igGrid("dataBind");

        var filterText = $("#GridProductAssociations").data("filterText");
        
        if (!checkNullOrUndefined(filterText)) {
            applyFilter();
        }

        if (!checkNullOrUndefined(newProduct)) {
            $("#GridProductAssociations").data("CMSProdID", newProduct);
            $("#GridProductAssociations").igGridFiltering("filter", []);
            $("#GridProductAssociations").igGridFiltering("filter",
                [{ fieldName: "PRODID", expr: newProduct, cond: "equals" },
                ],
                true);
        }

    }
    function applyFilter() {
        <%--reapply filter if any--%>
        var columnKey = $("#GridProductAssociations").data("columnKey");
        var filterText = $("#GridProductAssociations").data("filterText");
        if (checkNullOrUndefined(columnKey) == false) {
            $("#GridProductAssociations").igGridFiltering("filter", ([{
                fieldName: columnKey,
                expr: filterText.toString(),
                cond: "contains"
            }]), true);
        }

    }
    function onFail_getProductsAndAssociationsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getProductsAndAssociationsGridData");
    }


    function onSuccess_addNewPatternProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailablePatterns(isRebind, cmsProdID, onSuccess_getAvailablePatterns, onFail_getAvailablePatterns, isRebind);
        PageMethods.getPatternsGridData(cmsProdID, onSuccess_getPatternsGridData, onFail_getPatternsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
        
    }
    function onFail_addNewPatternProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_addNewPatternProductRelationship");
    }

    function onSuccess_editPatternProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailablePatterns(isRebind, cmsProdID, onSuccess_getAvailablePatterns, onFail_getAvailablePatterns, isRebind);
        PageMethods.getPatternsGridData(cmsProdID, onSuccess_getPatternsGridData, onFail_getPatternsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)

    }
    function onFail_editPatternProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_editPatternProductRelationship");
    }
    function onSuccess_disablePatternProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailablePatterns(isRebind, cmsProdID, onSuccess_getAvailablePatterns, onFail_getAvailablePatterns, isRebind);
        PageMethods.getPatternsGridData(cmsProdID, onSuccess_getPatternsGridData, onFail_getPatternsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
        
    }
    function onFail_disablePatternProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_disablePatternProductRelationship");
    }

    function onSuccess_addNewTankProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridTanks").igGrid("databind");
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableTanks(isRebind, cmsProdID, onSuccess_getAvailableTanks, onFail_getAvailableTanks, isRebind);
        PageMethods.getTanksGridData(cmsProdID, onSuccess_getTanksGridData, onFail_getTanksGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)

    }
    function onFail_addNewTankProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_addNewTankProductRelationship");
    }

    function onSuccess_editTankProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridTanks").igGrid("databind");
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableTanks(isRebind, cmsProdID, onSuccess_getAvailableTanks, onFail_getAvailableTanks, isRebind);
        PageMethods.getTanksGridData(cmsProdID, onSuccess_getTanksGridData, onFail_getTanksGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)

    }
    function onFail_editTankProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_editTankProductRelationship");
    }

    function onSuccess_disableTankProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridTanks").igGrid("databind");
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableTanks(isRebind, cmsProdID, onSuccess_getAvailableTanks, onFail_getAvailableTanks, isRebind);
        PageMethods.getTanksGridData(cmsProdID, onSuccess_getTanksGridData, onFail_getTanksGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
        

    }

    function onFail_disableTankProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_disableTankProductRelationship");
    }


    function onSuccess_addNewSpotProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridSpots").igGrid("databind");
        
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableSpots(isRebind, cmsProdID, onSuccess_getAvailableSpots, onFail_getAvailableSpots, isRebind);
        PageMethods.getSpotsGridData(cmsProdID, onSuccess_getSpotsGridData, onFail_getSpotsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
        
    }
    function onFail_addNewSpotProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_addNewSpotProductRelationship");
    }

    function onSuccess_editSpotProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridSpots").igGrid("databind");

        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableSpots(isRebind, cmsProdID, onSuccess_getAvailableSpots, onFail_getAvailableSpots, isRebind);
        PageMethods.getSpotsGridData(cmsProdID, onSuccess_getSpotsGridData, onFail_getSpotsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)

    }
    function onFail_editSpotProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_editSpotProductRelationship");
    }
    function onSuccess_disableSpotProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridSpots").igGrid("databind");

        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableSpots(isRebind, cmsProdID, onSuccess_getAvailableSpots, onFail_getAvailableSpots, isRebind);
        PageMethods.getSpotsGridData(cmsProdID, onSuccess_getSpotsGridData, onFail_getSpotsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
    }

    function onFail_disableSpotProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_disableSpotProductRelationship");
    }


    function onSuccess_AddProductToDBIfNonexistent(value, ctx, methodName) {
        if (!checkNullOrUndefined(value)) {
            $("#lblAddProduct").text(String(value));
        }
        var newProduct = $("#cboxCMSProducts").igCombo("value");
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData, newProduct)


        $("#dvGridItems").css("display", "block");
    }
    function onFail_AddProductToDBIfNonexistent(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_AddProductToDBIfNonexistent");
    }

    function onSuccess_getProductsFromCMS(value, ctx, methodName) {

        var cboxData = [];
        cboxData.length = 0;
        for (i = 0; i < value.length; i++) {
            cboxData[i] = { "PROD": value[i] };
        }
        $("#cboxCMSProducts").igCombo("option", "dataSource", cboxData);
        $("#cboxCMSProducts").igCombo("dataBind");

    }

    function onFail_getProductsFromCMS(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getProductsFromCMS");

    }



    function onSuccess_getAvailablePatterns(value, ctx, methodName) {

        var isRebind = ctx;
        if (!isRebind) {
            GLOBAL_PATTERN_OPTIONS = [];
            GLOBAL_PATTERN_OPTIONS.length = 0;
        }

        var newData = [];
        for (i = 0; i < value.length; i++) {
            if (!isRebind) {
                GLOBAL_PATTERN_OPTIONS[i] = { "PATTERNID": value[i][0], "PATTERNNAME": value[i][1], "PATTERNPATH": value[i][2], "PATTERNFILENAME": value[i][3], "PATTERNFILENAMEOLD": value[i][4] };
            }
            newData[i] = { "PATTERNID": value[i][0], "PATTERNNAME": value[i][1], "PATTERNPATH": value[i][2], "PATTERNFILENAME": value[i][3], "PATTERNFILENAMEOLD": value[i][4] };
        }

        if (isRebind) {
            $("#cboxPatternOptions").igCombo("option", "dataSource", newData);
            $("#cboxPatternOptions").igCombo("dataBind");

            var patternID = $("#cboxTankOptions").data("tankID");
            if (patternID) {
                $("#cboxPatternOptions").igCombo('value', patternID);
            }

        }

    }

    function onFail_getAvailablePatterns(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getAvailablePatterns");
    }

    function onSuccess_getAvailableSpots(value, ctx, methodName) {

        var isRebind = ctx;
        if (!isRebind) {
            GLOBAL_SPOT_OPTIONS = [];
            GLOBAL_SPOT_OPTIONS.length = 0;
        }

        var newData = [];
        for (i = 0; i < value.length; i++) {
            if (!isRebind) {
                GLOBAL_SPOT_OPTIONS[i] = { "SPOTID": value[i][0], "SPOTDESC": value[i][1], "SPOTTYPE": value[i][2] };
            }
            newData[i] = { "SPOTID": value[i][0], "SPOTDESC": value[i][1], "SPOTTYPE": value[i][2] };
        }

        if (isRebind) {
            $("#cboxSpotOptions").igCombo("option", "dataSource", newData);
            $("#cboxSpotOptions").igCombo("dataBind");

            var spotID = $("#cboxSpotOptions").data("spotID");
            if (spotID) {
                $("#cboxSpotOptions").igCombo('value', spotID);
            }
        }

    }

    function onFail_getAvailableSpots(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getAvailableSpots");
    }


    function onSuccess_getAvailableTanks(value, ctx, methodName) {

        var isRebind = ctx;
        if (!isRebind) {
            GLOBAL_TANK_OPTIONS = [];
            GLOBAL_TANK_OPTIONS.length = 0;
        }

        var newData = [];
        for (i = 0; i < value.length; i++) {
            if (!isRebind) {
                GLOBAL_TANK_OPTIONS[i] = { "TANKID": value[i][0], "TANKNAME": value[i][1], "TANKCAP": value[i][2] };
            }
            newData[i] = { "TANKID": value[i][0], "TANKNAME": value[i][1], "TANKCAP": value[i][2] };
        }
       
        if (isRebind) {
            $("#cboxTankOptions").igCombo("option", "dataSource", newData);
            $("#cboxTankOptions").igCombo("dataBind");

            var tankID = $("#cboxTankOptions").data("tankID");
            if (tankID) {
                $("#cboxTankOptions").igCombo('value', tankID);
            }

        }
        
    }

    function onFail_getAvailableTanks(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getAvailableTanks");
    }


    function onSuccess_getTanksGridData(value, ctx, methodName) {
        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "TANKPRODID": value[i][0], "TANKID": value[i][1], "TANKNAME": value[i][2], "TANKCAP": value[i][3] };
        }
        $("#GridTanks").igGrid("option", "dataSource", gridData);
        $("#GridTanks").igGrid("dataBind");


    }

    function onFail_getTanksGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getTanksGridData");
    }

    function onSuccess_getSpotsGridData(value, ctx, methodName) {
        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "SPOTPRODID": value[i][0], "SPOTID": value[i][1], "SPOTDESC": value[i][2], "SPOTTYPE": value[i][3] };
        }
        $("#GridSpots").igGrid("option", "dataSource", gridData);
        $("#GridSpots").igGrid("dataBind");

    }

    function onFail_getSpotsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getSpotsGridData");
    }

   
    function onSuccess_getInspectionListsGridData(value, ctx, methodName) {

        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "INSPPRODID": value[i][0], "INSPLISTID": value[i][1], "INSPLISTNAME": value[i][2], };
        }
        $("#GridInspectionLists").igGrid("option", "dataSource", gridData);
        $("#GridInspectionLists").igGrid("dataBind");

    }

    function onFail_getInspectionListsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getInspectionListsGridData");
    }

    function onSuccess_getAvailableInspectionLists(value, ctx, methodName) {

        var isRebind = ctx;
        if (!isRebind) {
            GLOBAL_INSPECTIONLIST_OPTIONS = [];
            GLOBAL_INSPECTIONLIST_OPTIONS.length = 0;
        }

        var newData = [];
        for (i = 0; i < value.length; i++) {
            if (!isRebind) {
                GLOBAL_INSPECTIONLIST_OPTIONS[i] = { "INSPLISTID": value[i][0], "INSPLISTNAME": value[i][1] }
            }
                newData[i] = { "INSPLISTID": value[i][0], "INSPLISTNAME": value[i][1], };
        }

        if (isRebind) {
            $("#cboxInspectionListOptions").igCombo("option", "dataSource", newData);
            $("#cboxInspectionListOptions").igCombo("dataBind");

            var listID = $("#cboxInspectionListOptions").data("inspectionListID");
            if (listID) {
                $("#cboxInspectionListOptions").igCombo('value', listID);
            }
            
        }

    }

    function onFail_getAvailableInspectionLists(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getAvailableInspectionLists");
    }

    function onSuccess_addNewInspectionListProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableInspectionLists(isRebind, cmsProdID, onSuccess_getAvailableInspectionLists, onFail_getAvailableInspectionLists, isRebind);
        PageMethods.getInspectionListsGridData(cmsProdID, onSuccess_getInspectionListsGridData, onFail_getInspectionListsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
    }
    function onFail_addNewInspectionListProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_addNewInspectionListProductRelationship");
    }

    function onSuccess_editInspectionListProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableInspectionLists(isRebind, cmsProdID, onSuccess_getAvailableInspectionLists, onFail_getAvailableInspectionLists, isRebind);
        PageMethods.getInspectionListsGridData(cmsProdID, onSuccess_getInspectionListsGridData, onFail_getInspectionListsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
    }
    function onFail_editInspectionListProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_editInspectionListProductRelationship");
    }

    function onSuccess_disableInspectionListProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.getAvailableInspectionLists(isRebind, cmsProdID, onSuccess_getAvailableInspectionLists, onFail_getAvailableInspectionLists, isRebind);
        PageMethods.getInspectionListsGridData(cmsProdID, onSuccess_getInspectionListsGridData, onFail_getInspectionListsGridData);
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridDataRebind, onFail_getProductsAndAssociationsGridData)
    }
    function onFail_disableInspectionListProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_disableInspectionListProductRelationship");
    }

    function onSuccess_getPatternsGridData(value, ctx, methodName) {

        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "PATTERNPRODID": value[i][0], "PATTERNID": value[i][1], "PATTERNNAME": value[i][2], "PATTERNPATH": value[i][3] , "PATTERNFILENAME": value[i][4], "PATTERNFILENAMEOLD": value[i][5]};
        }
        $("#GridPatterns").igGrid("option", "dataSource", gridData);
        $("#GridPatterns").igGrid("dataBind");

    }

    function onFail_getPatternsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_getPatternsGridData");
    }


    //------------------------------------------------------------------

    function ResetText() {
        $("#lblAddProduct").text("");
        $("#GridTanks tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text("");
        $("#GridSpots tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text("");
        $("#GridInspections tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text("");
        $("#GridInspectionLists tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(0)").text("");
    }
    function initGrid() {
        

        $("#GridTanks").igGrid({
            dataSource: [{ "TANKPRODID": "", "TANKID": "", "TANKNAME":"", "TANKCAP": "" }],
            width: "50%",
            virtualization: false,
            autoGenerateColumns: true,
            renderCheckboxes: true,
            autoCommit: true,
            primaryKey: "TANKPRODID",
            columns:
                [
                    { headerText: "", key: "TANKPRODID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "TANKID", dataType: "number", width: "0%", hidden: true },
                   // { headerText: "Tank Name", key: "TANKNAME", dataType: "string", width: "50%" },
                    {
                        headerText: "Tank Name", key: "TANKNAME", unbound: true, dataType: "number", width: "50%", formula: function (row, grid) { return returnItemFromArray(GLOBAL_TANK_OPTIONS, "TANKID", row.TANKID, "TANKNAME"); }
                    },
                    { headerText: "Tank Capacity", key: "TANKCAP", dataType: "string", width: "50%" },
                    
                ],
            features: [
            
                {
                    name: 'Sorting'
                },
                 {
                     name: 'Updating',
                     enableAddRow: true,
                     editMode: "row",
                     enableDeleteRow: true,
                     enableDataDirtyException: false,
                     editRowEnding: function (evt, ui) {
                         var origEvent = evt.originalEvent;
                         if (typeof origEvent === "undefined") {
                             return false;
                         }
                         
                         if ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) {
                             var row = ui.owner.grid.findRecordByKey(ui.rowID);

                             //adding tank
                             if (ui.update == true && ui.rowAdding == true) {
                                 //add code here
                                 var tankName = ui.values.TANKNAME;
                                 var prodID = $("#GridProductAssociations").data("CMSProdID");
                                 PageMethods.addNewTankProductRelationship(tankName, prodID, onSuccess_addNewTankProductRelationship, onFail_addNewTankProductRelationship);
                             }
                                 //edit tank
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var tankID = ui.values.TANKNAME; //newtankID
                                 PageMethods.editTankProductRelationship(tankID, ui.rowID, onSuccess_editTankProductRelationship, onFail_editTankProductRelationship);
                             }
                         }
                         else {
                             return false;
                         }
                     
                     },
                     rowDeleting: function (evt, ui) {
                         //var origEvent = evt.originalEvent;
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);

                         var r = confirm("Continue deleting association with tank: " + row.TANKNAME + "?");
                         if (r == true) {
                             var tankprodID = row.TANKPRODID;
                             PageMethods.disableTankProductRelationship(tankprodID, onSuccess_disableTankProductRelationship, onFail_disableTankProductRelationship);
                             
                        }
                     },
                     columnSettings:
                        [
                            { columnKey: "TANKPRPODID", readOnly: true },
                            { columnKey: "TANKID", readOnly: true },
                            { columnKey: "TANKCAP", readOnly: true },
                            {
                                columnKey: "TANKNAME",
                                editorType: "combo",
                               // required: true,
                                editorOptions: {
                                    mode: "editable",
                                    filtertingType: "local",
                                    highlightMatchesMode: "contains",
                                    filteringCondition: "contains",
                                    dataSource: GLOBAL_TANK_OPTIONS,
                                    id: "cboxTankOptions",
                                    textKey: "TANKNAME",
                                    valueKey: "TANKID",
                                    autoSelectFirstMatch: true,
                                    virtualization: true,
                                    dropDownOpening: function (evt, ui) {
                                        $("#GridTanks tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text("");
                                     
                                        var isRebind = true;
                                        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
                                        PageMethods.getAvailableTanks(isRebind, cmsProdID, onSuccess_getAvailableTanks, onFail_getAvailableTanks, isRebind);
                                    },
                                    selectionChanged: function (evt, ui) {

                                        if (!checkNullOrUndefined(ui.items)) {
                                            var tankID = ui.items[0].data.TANKID;
                                            $("#cboxTankOptions").data("tankID", tankID);
                                           // var prodID = $("#cboxCMSProducts").data("CMSProdID");
                                            var tankCapacity = returnItemFromArray(GLOBAL_TANK_OPTIONS, 'TANKID', tankID, 'TANKCAP');
                                            if (tankCapacity) {
                                                //change value of html 
                                               $("#GridTanks tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text(tankCapacity);
                                            }

                                        }
                                    }
                                },
                            },
                        ]
                 }
            ]
        });


        $("#GridSpots").igGrid({
            dataSource: [],
            width: "50%",
            virtualization: false,
            autoGenerateColumns: true,
            renderCheckboxes: true,
            autoCommit: true,
            primaryKey: "SPOTPRODID",
            columns:
                [
                    { headerText: "", key: "SPOTPRODID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "SPOTID", dataType: "number", width: "0%", hidden: true },
                    {
                        headerText: "Spot Description", key: "SPOTDESC", unbound: true, dataType: "string", width: "50%", formula: function (row, grid) { return returnItemFromArray(GLOBAL_SPOT_OPTIONS, "SPOTID", row.SPOTID, "SPOTDESC"); }
                    },
                   // { headerText: "Spot Description", key: "SPOTDESC", dataType: "string", width: "50%" },
                    { headerText: "Spot Type", key: "SPOTTYPE", dataType: "string", width: "50%" },

                ],
            features: [

                {
                    name: 'Sorting'
                },
                 {
                     name: 'Updating',
                     enableAddRow: true,
                     editMode: "row",
                     enableDeleteRow: true,
                     enableDataDirtyException: false,
                     editRowEnding: function (evt, ui) {
                         var origEvent = evt.originalEvent;
                         if (typeof origEvent === "undefined") {
                             ui.keepEditing = true;
                             return false;
                         }
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);
                         if ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) {

                             //adding Dock
                             if (ui.update == true && ui.rowAdding == true) {
                                 //add code here
                                 var spotName = ui.values.SPOTDESC;
                                 var prodID = $("#GridProductAssociations").data("CMSProdID");
                                 PageMethods.addNewSpotProductRelationship(spotName, prodID, onSuccess_addNewSpotProductRelationship, onFail_addNewSpotProductRelationship);
                             }
                                 //edit Dock
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var spotID = ui.values.SPOTDESC; //new spotID
                                 PageMethods.editSpotProductRelationship(spotID, ui.rowID, onSuccess_editSpotProductRelationship, onFail_editSpotProductRelationship);
                             }
                         }
                         else {
                             return false;
                         }
                     },
                     rowDeleting: function (evt, ui) {
                         //var origEvent = evt.originalEvent;
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);

                         var r = confirm("Continue deleting association with spot: " + row.SPOTDESC + "?");
                         if (r == true) {
                             var spotprodID = row.SPOTPRODID;
                             PageMethods.disableSpotProductRelationship(spotprodID, onSuccess_disableSpotProductRelationship, onFail_disableSpotProductRelationship);
                           
                         }
                     },
                     columnSettings:
                         [
                             { columnKey: "SPOTPRODID", readOnly: true },
                             { columnKey: "SPOTID", readOnly: true },
                             { columnKey: "SPOTTYPE", readOnly: true },
                             {
                                 columnKey: "SPOTDESC",
                                 editorType: "combo",
                                 required: true,
                                 editorOptions: {
                                     mode: "editable",
                                     filtertingType: "local",
                                     highlightMatchesMode: "contains",
                                     filteringCondition: "contains",
                                     dataSource: GLOBAL_SPOT_OPTIONS,
                                     //itemTemplate: "<span title=\"${TANKNAME}\">${TANKNAME}</span>",
                                     id: "cboxSpotOptions",
                                     textKey: "SPOTDESC",
                                     valueKey: "SPOTID",
                                     autoSelectFirstMatch: false,
                                     virtualization: true,
                                     dropDownOpening: function (evt, ui) {
                                         $("#GridSpots tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text("");

                                         var isRebind = true;
                                         var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
                                         PageMethods.getAvailableSpots(isRebind, cmsProdID, onSuccess_getAvailableSpots, onFail_getAvailableSpots, isRebind);
                                     },
                                     selectionChanged: function (evt, ui) {
                                     
                                         if (!checkNullOrUndefined(ui.items)) {
                                             var spotID = ui.items[0].data.SPOTID;
                                             $("#cboxSpotOptions").data("spotID", spotID);
                                             var spotType = returnItemFromArray(GLOBAL_SPOT_OPTIONS, 'SPOTID',spotID, 'SPOTTYPE');
                                             if (spotType) {
                                                 //change value of html 
                                                 $("#GridSpots tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text(spotType);
                                             }
                                         }
                                     }
                                 },
                             },
                         ]
                 }
            ]
        });


        $("#GridPatterns").igGrid({
            dataSource: [],
            width: "50%",
            virtualization: false,
            autoGenerateColumns: true,
            renderCheckboxes: true,
            autoCommit: true,
            primaryKey: "PATTERNPRODID",
            columns:
                [
                    { headerText: "", key: "PATTERNPRODID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "PATTERNID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "PATTERNPATH", dataType: "number", width: "0%", hidden: true },
                   // { headerText: "Pattern Name", key: "PATTERNNAME", dataType: "string", width: "50%" },
                    {
                        headerText: "Pattern Name", key: "PATTERNNAME", unbound: true, dataType: "string", width: "50%", formula: function (row, grid) { return returnItemFromArray(GLOBAL_PATTERN_OPTIONS, "PATTERNID", row.PATTERNID, "PATTERNNAME"); }
                    },
                    { headerText: "Pattern File", key: "PATTERNFILENAME", dataType: "string", width: "50%", template: "<div><a href='${PATTERNPATH}\${PATTERNFILENAME}'>${PATTERNFILENAMEOLD}</a></div>" },
                ],
            features: [

                {
                    name: 'Sorting'
                },
                 {
                     name: 'Updating',
                     enableAddRow: true,
                     editMode: "row",
                     enableDeleteRow: true,
                     enableDataDirtyException: false,
                     editRowEnding: function (evt, ui) {
                         var origEvent = evt.originalEvent;
                         if (typeof origEvent === "undefined") {
                             ui.keepEditing = true;
                             return false;
                         }
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);
                         if ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) {

                             //adding Dock
                             if (ui.update == true && ui.rowAdding == true) {
                                 //add code here
                                 var patternName = ui.values.PATTERNNAME;// $("#cboxPatternOptions").igCombo('value');
                                 var prodID = $("#GridProductAssociations").data("CMSProdID");
                                 PageMethods.addNewPatternProductRelationship(patternName, prodID, onSuccess_addNewPatternProductRelationship, onFail_addNewPatternProductRelationship);
                             }
                                 //edit Dock
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var patternID = ui.values.PATTERNNAME; //new spotID
                                 PageMethods.editPatternProductRelationship(patternID, ui.rowID, onSuccess_editPatternProductRelationship, onFail_editPatternProductRelationship);
                             }
                         }
                         else {
                             return false;
                         }
                     },
                     rowDeleting: function (evt, ui) {
                         //var origEvent = evt.originalEvent;
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);

                         var r = confirm("Continue deleting association with pattern: " + row.PATTERNFILENAMEOLD + "?");
                         if (r == true) {
                             var patternprodID = row.PATTERNPRODID;
                             PageMethods.disablePatternProductRelationship(patternprodID, onSuccess_disablePatternProductRelationship, onFail_disablePatternProductRelationship);
                             
                         }
                     },
                     columnSettings:
                         [
                             { columnKey: "PATTERNPRODID", readOnly: true },
                             { columnKey: "PATTERNID", readOnly: true },
                             { columnKey: "PATTERNPATH", readOnly: true },
                             { columnKey: "PATTERNFILENAME", readOnly: true },
                             {
                                 columnKey: "PATTERNNAME",
                                 editorType: "combo",
                                 required: true,
                                 editorOptions: {
                                     mode: "editable",
                                     filtertingType: "local",
                                     highlightMatchesMode: "contains",
                                     filteringCondition: "contains",
                                     dataSource: GLOBAL_SPOT_OPTIONS,
                                     //itemTemplate: "<span title=\"${TANKNAME}\">${TANKNAME}</span>",
                                     id: "cboxPatternOptions",
                                     textKey: "PATTERNNAME",
                                     valueKey: "PATTERNID",
                                     autoSelectFirstMatch: false,
                                     virtualization: true,
                                     dropDownOpening: function (evt, ui) {
                                         $("#GridPatterns tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text("");

                                         var isRebind = true;
                                         var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
                                         PageMethods.getAvailablePatterns(isRebind, cmsProdID, onSuccess_getAvailablePatterns, onFail_getAvailablePatterns, isRebind);
                                     },
                                     selectionChanged: function (evt, ui) {

                                         if (!checkNullOrUndefined(ui.items)) {
                                             var patternID = ui.items[0].data.PATTERNID;
                                             $("#cboxPatternOptions").data("patternID", patternID);
                                             var patternFileOld = returnItemFromArray(GLOBAL_PATTERN_OPTIONS, 'PATTERNID', patternID, 'PATTERNFILENAMEOLD');
                                             if (patternFileOld) {
                                                 //change value of html 
                                                 $("#GridPatterns tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(2)").text(patternFileOld);
                                             }
                                         }
                                     }
                                 },
                             },

                         ]
                 }
            ]
        });


   


        $("#GridInspectionLists").igGrid({
            dataSource: [],
            width: "50%",
            virtualization: false,
            autoGenerateColumns: true,
            renderCheckboxes: true,
            autoCommit: true,
            primaryKey: "INSPPRODID",
            columns:
                [
                    { headerText: "", key: "INSPPRODID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "INSPLISTID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "Inspection List Name", key: "INSPLISTNAME", unbound: true, dataType: "string", width: "100%", formula: function (row, grid) { return returnItemFromArray(GLOBAL_INSPECTIONLIST_OPTIONS, "INSPLISTID", row.INSPLISTID, "INSPLISTNAME"); } },

                ],
            features: [

                {
                    name: 'Sorting'
                },
                 {
                     name: 'Updating',
                     enableAddRow: true,
                     editMode: "row",
                     enableDeleteRow: true,
                     editRowEnding: function (evt, ui) {
                         var origEvent = evt.originalEvent;
                         if (typeof origEvent === "undefined") {
                             ui.keepEditing = true;
                             return false;
                         }
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);
                         if ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13) {

                             //adding Dock
                             if (ui.update == true && ui.rowAdding == true) {
                                 //add code here
                                 var inspectListName = ui.values.INSPLISTNAME;
                                 var prodID = $("#GridProductAssociations").data("CMSProdID");
                                 if (inspectListName && prodID) {
                                     PageMethods.addNewInspectionListProductRelationship(inspectListName, prodID, onSuccess_addNewInspectionListProductRelationship, onFail_addNewInspectionListProductRelationship);
                                 }
                             }
                                 //edit Dock
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var inspectListID = ui.values.INSPLISTNAME; //new spotID
                                 PageMethods.editInspectionListProductRelationship(inspectListID, ui.rowID, onSuccess_editInspectionListProductRelationship, onFail_editInspectionListProductRelationship);
                             }
                             else {
                                 return false;
                             }
                         }
                     },
                     rowDeleting: function (evt, ui) {
                         //var origEvent = evt.originalEvent;
                         var row = ui.owner.grid.findRecordByKey(ui.rowID);

                         var r = confirm("Continue deleting association with inspection list: " + row.INSPLISTNAME + "?");
                         if (r == true) {
                             var inpsectionListProdID = row.INSPPRODID;
                             PageMethods.disableInspectionListProductRelationship(inpsectionListProdID, onSuccess_disableInspectionListProductRelationship, onFail_disableInspectionListProductRelationship);
                             
                         }
                     },
                     columnSettings:
                         [
                             { columnKey: "INSPPRODID", readOnly: true },
                             { columnKey: "INSPLISTID", readOnly: true },
                             {
                                 columnKey: "INSPLISTNAME",
                                editorType: "combo",
                                required: true,
                                editorOptions: {
                                    mode: "editable",
                                    filtertingType: "local",
                                    highlightMatchesMode: "contains",
                                    filteringCondition: "contains",
                                    dataSource: GLOBAL_INSPECTIONLIST_OPTIONS,
                                    id: "cboxInspectionListOptions",
                                    textKey: "INSPLISTNAME",
                                    valueKey: "INSPLISTID",
                                    autoSelectFirstMatch: false,
                                    virtualization: true,
                                    dropDownOpening: function (evt, ui) {
                                        $("#GridInspectionLists tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(0)").text("");
                                        var isRebind = true;
                                        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
                                        PageMethods.getAvailableInspectionLists(isRebind, cmsProdID, onSuccess_getAvailableInspectionLists, onFail_getAvailableInspectionLists, isRebind);
                                    },
                                    selectionChanged: function (evt, ui) {
                                        //if (!checkNullOrUndefined(ui.items)) {
                                        //    var listID = ui.items[0].data.INSPLISTID;
                                        //    $("#cboxInspectionListOptions").data("inspectionListID", listID);
                                        //    var listname = returnItemFromArray(GLOBAL_INSPECTIONLIST_OPTIONS, 'INSPLISTID', listID, 'INSPLISTNAME');
                                        //    if (listname) {
                                        //        //change value of html 
                                        //        $("#GridInspectionLists tr[data-new-row='true'] td.ui-iggrid-editingcell:nth-child(0)").text(listname);
                                        //    }
                                        //}
                                    }
                                },//end pattername column declaration
                             },
                         ]
                 }
            ]
        });

        <%-- change label on grid add new row--%>
        $("#dvGridTanks span.anr_t:contains('Add new row')").text("Click to choose existing tank to associate to product"); 
        $("#dvGridSpots span.anr_t:contains('Add new row')").text("Click to choose existing spot to associate to product");
        $("#dvGridPatterns span.anr_t:contains('Add new row')").text("Click to choose existing pattern  to associate to product");
        $("#GridInspectionLists span.anr_t:contains('Add new row')").text("Click to choose existing inspection list to associate to product");
        


    } //end initGrid

    
<%-------------------------------------------------------
Click Handlers
-------------------------------------------------------%>
    function onClick_AddProduct() {
        var product = $("#cboxCMSProducts").igCombo('value');
        if (product && product.length > 0 ) {
            PageMethods.AddProductToDBIfNonexistent(product, onSuccess_AddProductToDBIfNonexistent, onFail_AddProductToDBIfNonexistent);
        }
        
    }


<%-------------------------------------------------------
Initialize Infragistics IgniteUI Controls
-------------------------------------------------------%>
    $(function () {

        var isRebind = false;
     
        PageMethods.getAvailableTanks(isRebind, null, onSuccess_getAvailableTanks, onFail_getAvailableTanks, isRebind);
        PageMethods.getAvailableSpots(isRebind, null, onSuccess_getAvailableSpots, onFail_getAvailableSpots, isRebind);
        PageMethods.getAvailablePatterns(isRebind, null, onSuccess_getAvailablePatterns, onFail_getAvailablePatterns, isRebind);
        PageMethods.getAvailableInspectionLists(isRebind, null, onSuccess_getAvailableInspectionLists, onFail_getAvailableInspectionLists, isRebind);

        $("#cboxCMSProducts").igCombo({
            dataSource: [{ "PROD": null }],
            textKey: "PROD",
            valueKey: "PROD",
            width: "200px",
            mode: "editable",
            highlightMatchesMode: "contains",
            filteringCondition: "contains",
            autoSelectFirstMatch: false,
            virtualization: true,
            selectionChanged: function (evt, ui) {
                
                $("#dvGridItems").css("display", "none");
                $("#GridProductAssociations").igGridFiltering("filter", []);
                ResetText();
                $("#cboxCMSProducts").data("CMSProdID", null);

                if (!checkNullOrUndefined(ui.items)) {

                    var prodID = ui.items[0].data.PROD;

                    PageMethods.getTanksGridData(prodID, onSuccess_getTanksGridData, onFail_getTanksGridData);
                    PageMethods.getSpotsGridData(prodID, onSuccess_getSpotsGridData, onFail_getSpotsGridData);
                    PageMethods.getPatternsGridData(prodID, onSuccess_getPatternsGridData, onFail_getPatternsGridData);
                    PageMethods.getInspectionListsGridData(prodID, onSuccess_getInspectionListsGridData, onFail_getInspectionListsGridData);

                    $("#cboxCMSProducts").data("CMSProdID", prodID);
                }

            }
        });

        $("#GridProductAssociations").igGrid({
            dataSource: [{ "PRODID": "", "PRODNAME": "", "TANKS": "", "INSPECTIONS": "", "PATTERNS": "", "SPOTS": "" }],
            width: "100%",
            virtualization: false,
            autoGenerateColumns: true,
            renderCheckboxes: true,
            autoCommit: true,
            primaryKey: "PRODID",
            autofitLastColumn: true,
            columns:
                [
                    { headerText: "CMS ProductID", key: "PRODID", dataType: "string", width: "300px", },
                    { headerText: "CMS ProductName", key: "PRODNAME", dataType: "string", width: "300px", },
                    { headerText: "Associated to Tanks", key: "TANKS", dataType: "string", width: "300px", },
                    { headerText: "Associated to Inspections", key: "INSPECTIONS", dataType: "string", width: "300px", },
                    { headerText: "Associated to Patterns", key: "PATTERNS", dataType: "string", width: "300px", },
                    { headerText: "Associated to Spots", key: "SPOTS", dataType: "string", width: "300px", },

                ],
            features: [
                {
                    name: "Filtering",
                    dataFiltered: function (evt, ui)
                    {
                        $("#GridProductAssociations").data("columnKey", ui.columnKey);
                        if (checkNullOrUndefined(ui.expressions)) {
                            $("#GridProductAssociations").data("filterText", null);
                        }
                        else {
                            $("#GridProductAssociations").data("filterText", ui.expressions[0].expr);
                            applyFilter();
                        }
                    }
                },
                {
                    name: 'Selection',
                    mode: 'row',
                    multipleSelection: false,
                    activation: false,
                    rowSelectionChanging: function (evt, ui) {
                        $("#dvGridItems").css("display", "none");
                        ResetText();
                        $("#GridProductAssociations").data("CMSProdID", null);
                    },
                    rowSelectionChanged: function (evt, ui) {
                        var prodID = ui.row.id;
                        //var row = ui.owner.grid.findRecordByKey(ui.row.id);


                        if (!checkNullOrUndefined(prodID)) {

                            PageMethods.getTanksGridData(prodID, onSuccess_getTanksGridData, onFail_getTanksGridData);
                            PageMethods.getSpotsGridData(prodID, onSuccess_getSpotsGridData, onFail_getSpotsGridData);
                            PageMethods.getPatternsGridData(prodID, onSuccess_getPatternsGridData, onFail_getPatternsGridData);
                            PageMethods.getInspectionListsGridData(prodID, onSuccess_getInspectionListsGridData, onFail_getInspectionListsGridData);

                            $("#dvGridItems").css("display", "block");
                            $("#GridProductAssociations").data("CMSProdID", prodID);
                        }

                    }
                },

                {
                    name: "Paging",
                    type: "local",
                    pageSize: 5
                },
                {
                    name: 'Sorting'
                },
                 {
                     name: 'Updating',
                     enableAddRow: false,
                     editMode: "row",
                     enableDeleteRow: true,
                     enableDataDirtyException: false,
                     //editRowEnding: function (evt, ui) {

                     //},
                     columnSettings:
                        [
                            { columnKey: "PRODID", readOnly: true },
                            { columnKey: "PRODNAME", readOnly: true },
                            { columnKey: "TANKS", readOnly: true },
                            { columnKey: "INSPECTIONS", readOnly: true },
                            { columnKey: "PATTERNS", readOnly: true },
                            { columnKey: "SPOTS", readOnly: true }
                        ]
                 }
            ]
        });

        PageMethods.getProductsFromCMS(onSuccess_getProductsFromCMS, onFail_getProductsFromCMS);
        <%--UNCOMMENT THE SECTION BETWEEN THE DASHED LINE IF YOU WOULD LIKE TO ADD A PRODUCT FROM CMS TO THE DATABASE--%>
        <%-------------------------------------------SECTION START-------------------------------------------%>
        <%--
        --%>
        <%-------------------------------------------SECTION END-------------------------------------------%>

       
        PageMethods.getProductsAndAssociationsGridData(onSuccess_getProductsAndAssociationsGridData, onFail_getProductsAndAssociationsGridData)
        initGrid();

    });




</script>
    
<%-------------------------------------------------------
HTML SECTION
-------------------------------------------------------%>
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
<h2> Products</h2>
<p>Associate Products to different items. Please make sure tanks, spots, and patterns have already been created and are available.</p>




<%--UNCOMMENT THE SECTION BETWEEN THE DASHED LINE IF YOU WOULD LIKE TO ADD A PRODUCT FROM CMS TO THE DATABASE--%>
<%-------------------------------------------SECTION START-------------------------------------------%>

<h3>Select Product</h3>
<span><input id="cboxCMSProducts" /></span>
<span> <button type="button" id="btnAddProduct" onclick='onClick_AddProduct()'>Add Product</button> <label id="lblAddProduct" style="color:darkgreen"></label></span>

<%-------------------------------------------SECTION END-------------------------------------------%>


<h3>Click a product row in the grid below to begin adding associations</h3>
<div><table id="GridProductAssociations"></table></div>

<div id="dvGridItems" style="display:none">
<h3>Associate to Existing Tanks</h3>
        <div id="dvGridTanks"><table id="GridTanks"></table></div>
<h3>Associate to Existing Spots</h3>
        <div id="dvGridSpots"><table id="GridSpots"></table></div>
<h3>Associate to Existing Patterns</h3>
        <div id="dvGridPatterns"><table id="GridPatterns"></table></div>
<h3>Associate to Existing Inspections List</h3>
    <div id="GridInspectionLists"><table id="GridInspections"></table></div>
    <br />
    <br />
    <br />
    <br />
</div>
    
</asp:Content>
