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
    var GLOBAL_ASSOCIATION;


    <%-------------------------------------------------------
    //Pagemethod functions
-------------------------------------------------------%>

    //ProductID_CMS, ProductName_CMS, TankData, InspectionListsData, PatternData, SpotData
    function onSuccess_GetProductsAndAssociationsGridData(value, ctx, methodName) {
        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "PRODID": value[i][0], "PRODNAME": value[i][1], "TANKS": value[i][2], "INSPECTIONS": value[i][3], "PATTERNS": value[i][4], "SPOTS": value[i][5] };
        }
        $("#GridProductAssociations").igGrid("option", "dataSource", gridData);
        $("#GridProductAssociations").igGrid("dataBind");
    }
    function onSuccess_GetProductsAndAssociationsGridDataRebind(value, newProduct, methodName) {
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
                [{ fieldName: "PRODID", expr: newProduct, cond: "equals" }
                ],
                true);
        }

    }
    function applyFilter() {
        <%--reapply filter if any--%>
        var columnKey = $("#GridProductAssociations").data("columnKey");
        var filterText = $("#GridProductAssociations").data("filterText");
        if (checkNullOrUndefined(columnKey) == false) {
            $("#GridProductAssociations").igGridFiltering("filter", [{
                fieldName: columnKey,
                expr: filterText.toString(),
                cond: "contains"
            }], true);
        }

    }
    function onFail_GetProductsAndAssociationsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetProductsAndAssociationsGridData");
    }


    function onSuccess_AddNewPatternProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailablePatterns(isRebind, cmsProdID, onSuccess_GetAvailablePatterns, onFail_GetAvailablePatterns, isRebind);
        PageMethods.GetPatternsGridData(cmsProdID, onSuccess_GetPatternsGridData, onFail_GetPatternsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
        
    }
    function onFail_AddNewPatternProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_AddNewPatternProductRelationship");
    }

    function onSuccess_EditPatternProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailablePatterns(isRebind, cmsProdID, onSuccess_GetAvailablePatterns, onFail_GetAvailablePatterns, isRebind);
        PageMethods.GetPatternsGridData(cmsProdID, onSuccess_GetPatternsGridData, onFail_GetPatternsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);

    }
    function onFail_EditPatternProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_EditPatternProductRelationship");
    }
    function onSuccess_DisablePatternProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailablePatterns(isRebind, cmsProdID, onSuccess_GetAvailablePatterns, onFail_GetAvailablePatterns, isRebind);
        PageMethods.GetPatternsGridData(cmsProdID, onSuccess_GetPatternsGridData, onFail_GetPatternsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
        
    }
    function onFail_DisablePatternProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_DisablePatternProductRelationship");
    }

    function onSuccess_AddNewTankProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridTanks").igGrid("databind");
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableTanks(isRebind, cmsProdID, onSuccess_GetAvailableTanks, onFail_GetAvailableTanks, isRebind);
        PageMethods.GetTanksGridData(cmsProdID, onSuccess_GetTanksGridData, onFail_GetTanksGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);

    }
    function onFail_AddNewTankProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_AddNewTankProductRelationship");
    }

    function onSuccess_EditTankProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridTanks").igGrid("databind");
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableTanks(isRebind, cmsProdID, onSuccess_GetAvailableTanks, onFail_GetAvailableTanks, isRebind);
        PageMethods.GetTanksGridData(cmsProdID, onSuccess_GetTanksGridData, onFail_GetTanksGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);

    }
    function onFail_EditTankProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_EditTankProductRelationship");
    }

    function onSuccess_DisableTankProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridTanks").igGrid("databind");
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableTanks(isRebind, cmsProdID, onSuccess_GetAvailableTanks, onFail_GetAvailableTanks, isRebind);
        PageMethods.GetTanksGridData(cmsProdID, onSuccess_GetTanksGridData, onFail_GetTanksGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
        

    }

    function onFail_DisableTankProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_DisableTankProductRelationship");
    }


    function onSuccess_AddNewSpotProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridSpots").igGrid("databind");
        
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableSpots(isRebind, cmsProdID, onSuccess_GetAvailableSpots, onFail_GetAvailableSpots, isRebind);
        PageMethods.GetSpotsGridData(cmsProdID, onSuccess_GetSpotsGridData, onFail_GetSpotsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
        
    }
    function onFail_AddNewSpotProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_AddNewSpotProductRelationship");
    }

    function onSuccess_EditSpotProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridSpots").igGrid("databind");

        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableSpots(isRebind, cmsProdID, onSuccess_GetAvailableSpots, onFail_GetAvailableSpots, isRebind);
        PageMethods.GetSpotsGridData(cmsProdID, onSuccess_GetSpotsGridData, onFail_GetSpotsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);

    }
    function onFail_EditSpotProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_EditSpotProductRelationship");
    }
    function onSuccess_DisableSpotProductRelationship(value, ctx, methodName) {
        //ResetText();
        //$("#GridSpots").igGrid("databind");

        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableSpots(isRebind, cmsProdID, onSuccess_GetAvailableSpots, onFail_GetAvailableSpots, isRebind);
        PageMethods.GetSpotsGridData(cmsProdID, onSuccess_GetSpotsGridData, onFail_GetSpotsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
    }

    function onFail_DisableSpotProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_DisableSpotProductRelationship");
    }


    function onSuccess_AddProductToDBIfNonexistent(value, ctx, methodName) {
        if (!checkNullOrUndefined(value)) {
            $("#lblAddProduct").text(String(value));
        }
        var newProduct = $("#cboxCMSProducts").igCombo("value");
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData, newProduct);


        $("#dvGridItems").css("display", "block");
    }
    function onFail_AddProductToDBIfNonexistent(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_AddProductToDBIfNonexistent");
    }

    function onSuccess_GetProductsFromCMS(value, ctx, methodName) {

        var cboxData = [];
        cboxData.length = 0;
        for (i = 0; i < value.length; i++) {
            cboxData[i] = { "PROD": value[i] };
        }
        $("#cboxCMSProducts").igCombo("option", "dataSource", cboxData);
        $("#cboxCMSProducts").igCombo("dataBind");


    }

    function onFail_GetProductsFromCMS(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetProductsFromCMS");

    }



    function onSuccess_GetAvailablePatterns(value, ctx, methodName) {

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

    function onFail_GetAvailablePatterns(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetAvailablePatterns");
    }

    function onSuccess_GetAvailableSpots(value, ctx, methodName) {

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

    function onFail_GetAvailableSpots(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetAvailableSpots");
    }


    function onSuccess_GetAvailableTanks(value, ctx, methodName) {

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

    function onFail_GetAvailableTanks(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetAvailableTanks");
    }


    function onSuccess_GetTanksGridData(value, ctx, methodName) {
        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "TANKPRODID": value[i][0], "TANKID": value[i][1], "TANKNAME": value[i][2], "TANKCAP": value[i][3] };
        }
        $("#GridTanks").igGrid("option", "dataSource", gridData);
        $("#GridTanks").igGrid("dataBind");


    }

    function onFail_GetTanksGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetTanksGridData");
    }

    function onSuccess_GetSpotsGridData(value, ctx, methodName) {
        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "SPOTPRODID": value[i][0], "SPOTID": value[i][1], "SPOTDESC": value[i][2], "SPOTTYPE": value[i][3] };
        }
        $("#GridSpots").igGrid("option", "dataSource", gridData);
        $("#GridSpots").igGrid("dataBind");

    }

    function onFail_GetSpotsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetSpotsGridData");
    }

   
    function onSuccess_GetInspectionListsGridData(value, ctx, methodName) {

        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "INSPPRODID": value[i][0], "INSPLISTID": value[i][1], "INSPLISTNAME": value[i][2] };
        }
        $("#GridInspectionLists").igGrid("option", "dataSource", gridData);
        $("#GridInspectionLists").igGrid("dataBind");

    }

    function onFail_GetInspectionListsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetInspectionListsGridData");
    }

    function onSuccess_GetAvailableInspectionLists(value, ctx, methodName) {

        var isRebind = ctx;
        if (!isRebind) {
            GLOBAL_INSPECTIONLIST_OPTIONS = [];
            GLOBAL_INSPECTIONLIST_OPTIONS.length = 0;
        }

        var newData = [];
        for (i = 0; i < value.length; i++) {
            if (!isRebind) {
                GLOBAL_INSPECTIONLIST_OPTIONS[i] = { "INSPLISTID": value[i][0], "INSPLISTNAME": value[i][1] };
            }
                newData[i] = { "INSPLISTID": value[i][0], "INSPLISTNAME": value[i][1] };
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

    function onFail_GetAvailableInspectionLists(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetAvailableInspectionLists");
    }

    function onSuccess_AddNewInspectionListProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableInspectionLists(isRebind, cmsProdID, onSuccess_GetAvailableInspectionLists, onFail_GetAvailableInspectionLists, isRebind);
        PageMethods.GetInspectionListsGridData(cmsProdID, onSuccess_GetInspectionListsGridData, onFail_GetInspectionListsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
    }
    function onFail_AddNewInspectionListProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_AddNewInspectionListProductRelationship");
    }

    function onSuccess_EditInspectionListProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableInspectionLists(isRebind, cmsProdID, onSuccess_GetAvailableInspectionLists, onFail_GetAvailableInspectionLists, isRebind);
        PageMethods.GetInspectionListsGridData(cmsProdID, onSuccess_GetInspectionListsGridData, onFail_GetInspectionListsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
    }
    function onFail_EditInspectionListProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_EditInspectionListProductRelationship");
    }

    function onSuccess_DisableInspectionListProductRelationship(value, ctx, methodName) {
        var isRebind = true;
        var cmsProdID = $("#GridProductAssociations").data("CMSProdID");
        ResetText();
        PageMethods.GetAvailableInspectionLists(isRebind, cmsProdID, onSuccess_GetAvailableInspectionLists, onFail_GetAvailableInspectionLists, isRebind);
        PageMethods.GetInspectionListsGridData(cmsProdID, onSuccess_GetInspectionListsGridData, onFail_GetInspectionListsGridData);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridDataRebind, onFail_GetProductsAndAssociationsGridData);
    }
    function onFail_DisableInspectionListProductRelationship(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_DisableInspectionListProductRelationship");
    }

    function onSuccess_GetPatternsGridData(value, ctx, methodName) {

        var gridData = [];
        gridData.length = 0;
        for (i = 0; i < value.length; i++) {
            gridData[i] = { "PATTERNPRODID": value[i][0], "PATTERNID": value[i][1], "PATTERNNAME": value[i][2], "PATTERNPATH": value[i][3] , "PATTERNFILENAME": value[i][4], "PATTERNFILENAMEOLD": value[i][5]};
        }
        $("#GridPatterns").igGrid("option", "dataSource", gridData);
        $("#GridPatterns").igGrid("dataBind");

    }

    function onFail_GetPatternsGridData(value, ctx, methodName) {
        sendtoErrorPage("Error in Admin_Products.aspx, onFail_GetPatternsGridData");
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
                    { headerText: "Tank Capacity", key: "TANKCAP", dataType: "string", width: "50%" }
                    
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
                                 PageMethods.AddNewTankProductRelationship(tankName, prodID, onSuccess_AddNewTankProductRelationship, onFail_AddNewTankProductRelationship);
                             }
                                 //edit tank
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var tankID = ui.values.TANKNAME; //newtankID
                                 PageMethods.EditTankProductRelationship(tankID, ui.rowID, onSuccess_EditTankProductRelationship, onFail_EditTankProductRelationship);
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
                             PageMethods.DisableTankProductRelationship(tankprodID, onSuccess_DisableTankProductRelationship, onFail_DisableTankProductRelationship);
                             
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
                                        PageMethods.GetAvailableTanks(isRebind, cmsProdID, onSuccess_GetAvailableTanks, onFail_GetAvailableTanks, isRebind);
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
                                }
                            }
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
                    { headerText: "Spot Type", key: "SPOTTYPE", dataType: "string", width: "50%" }

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
                                 PageMethods.AddNewSpotProductRelationship(spotName, prodID, onSuccess_AddNewSpotProductRelationship, onFail_AddNewSpotProductRelationship);
                             }
                                 //edit Dock
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var spotID = ui.values.SPOTDESC; //new spotID
                                 PageMethods.EditSpotProductRelationship(spotID, ui.rowID, onSuccess_EditSpotProductRelationship, onFail_EditSpotProductRelationship);
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
                             PageMethods.DisableSpotProductRelationship(spotprodID, onSuccess_DisableSpotProductRelationship, onFail_DisableSpotProductRelationship);
                           
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
                                         PageMethods.GetAvailableSpots(isRebind, cmsProdID, onSuccess_GetAvailableSpots, onFail_GetAvailableSpots, isRebind);
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
                                 }
                             }
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
                    { headerText: "Pattern File", key: "PATTERNFILENAME", dataType: "string", width: "50%", template: "<div><a href='${PATTERNPATH}\${PATTERNFILENAME}'>${PATTERNFILENAMEOLD}</a></div>" }
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
                                 PageMethods.AddNewPatternProductRelationship(patternName, prodID, onSuccess_AddNewPatternProductRelationship, onFail_AddNewPatternProductRelationship);
                             }
                                 //edit Dock
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var patternID = ui.values.PATTERNNAME; //new spotID
                                 PageMethods.EditPatternProductRelationship(patternID, ui.rowID, onSuccess_EditPatternProductRelationship, onFail_EditPatternProductRelationship);
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
                             PageMethods.DisablePatternProductRelationship(patternprodID, onSuccess_DisablePatternProductRelationship, onFail_DisablePatternProductRelationship);
                             
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
                                         PageMethods.GetAvailablePatterns(isRebind, cmsProdID, onSuccess_GetAvailablePatterns, onFail_GetAvailablePatterns, isRebind);
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
                                 }
                             }

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
                    { headerText: "Inspection List Name", key: "INSPLISTNAME", unbound: true, dataType: "string", width: "100%", formula: function (row, grid) { return returnItemFromArray(GLOBAL_INSPECTIONLIST_OPTIONS, "INSPLISTID", row.INSPLISTID, "INSPLISTNAME"); } }

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
                                     PageMethods.AddNewInspectionListProductRelationship(inspectListName, prodID, onSuccess_AddNewInspectionListProductRelationship, onFail_AddNewInspectionListProductRelationship);
                                 }
                             }
                                 //edit Dock
                             else if (ui.update == true && ui.rowAdding == false) {
                                 var inspectListID = ui.values.INSPLISTNAME; //new spotID
                                 PageMethods.EditInspectionListProductRelationship(inspectListID, ui.rowID, onSuccess_EditInspectionListProductRelationship, onFail_EditInspectionListProductRelationship);
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
                             PageMethods.DisableInspectionListProductRelationship(inpsectionListProdID, onSuccess_DisableInspectionListProductRelationship, onFail_DisableInspectionListProductRelationship);
                             
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
                                        PageMethods.GetAvailableInspectionLists(isRebind, cmsProdID, onSuccess_GetAvailableInspectionLists, onFail_GetAvailableInspectionLists, isRebind);
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
                                }//end pattername column declaration
                             }
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
    function onclick_toggle(toggleElement) {
        $(toggleElement).toggle();
    }


<%-------------------------------------------------------
Initialize Infragistics IgniteUI Controls
-------------------------------------------------------%>
    $(function () {

        var isRebind = false;
     
        PageMethods.GetAvailableTanks(isRebind, null, onSuccess_GetAvailableTanks, onFail_GetAvailableTanks, isRebind);
        PageMethods.GetAvailableSpots(isRebind, null, onSuccess_GetAvailableSpots, onFail_GetAvailableSpots, isRebind);
        PageMethods.GetAvailablePatterns(isRebind, null, onSuccess_GetAvailablePatterns, onFail_GetAvailablePatterns, isRebind);
        PageMethods.GetAvailableInspectionLists(isRebind, null, onSuccess_GetAvailableInspectionLists, onFail_GetAvailableInspectionLists, isRebind);

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

                    PageMethods.GetTanksGridData(prodID, onSuccess_GetTanksGridData, onFail_GetTanksGridData);
                    PageMethods.GetSpotsGridData(prodID, onSuccess_GetSpotsGridData, onFail_GetSpotsGridData);
                    PageMethods.GetPatternsGridData(prodID, onSuccess_GetPatternsGridData, onFail_GetPatternsGridData);
                    PageMethods.GetInspectionListsGridData(prodID, onSuccess_GetInspectionListsGridData, onFail_GetInspectionListsGridData);

                    $("#cboxCMSProducts").data("CMSProdID", prodID);
                }

            }
        });
        $(".ui-igcombo-wrapper").css('vertical-align', 'bottom');

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
                    { headerText: "CMS ProductID", key: "PRODID", dataType: "string", width: "300px" },
                    { headerText: "CMS ProductName", key: "PRODNAME", dataType: "string", width: "300px" },
                    { headerText: "Associated to Tanks", key: "TANKS", dataType: "string", width: "300px" },
                    { headerText: "Associated to Inspections", key: "INSPECTIONS", dataType: "string", width: "300px" },
                    { headerText: "Associated to Patterns", key: "PATTERNS", dataType: "string", width: "300px" },
                    { headerText: "Associated to Spots", key: "SPOTS", dataType: "string", width: "300px" }

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

                            PageMethods.GetTanksGridData(prodID, onSuccess_GetTanksGridData, onFail_GetTanksGridData);
                            PageMethods.GetSpotsGridData(prodID, onSuccess_GetSpotsGridData, onFail_GetSpotsGridData);
                            PageMethods.GetPatternsGridData(prodID, onSuccess_GetPatternsGridData, onFail_GetPatternsGridData);
                            PageMethods.GetInspectionListsGridData(prodID, onSuccess_GetInspectionListsGridData, onFail_GetInspectionListsGridData);

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

        PageMethods.GetProductsFromCMS(onSuccess_GetProductsFromCMS, onFail_GetProductsFromCMS);
        PageMethods.GetProductsAndAssociationsGridData(onSuccess_GetProductsAndAssociationsGridData, onFail_GetProductsAndAssociationsGridData);
        initGrid();

    });


    

</script>
    
<%-------------------------------------------------------
HTML SECTION
-------------------------------------------------------%>
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
<h2> Products</h2><br />
<p>Associate Products to different items. Please make sure tanks, spots, and patterns have already been created and are available.</p>

<h3 onclick="onclick_toggle('#dvAddToTruckSchedule')" class="Mi4_divButton">Add CMS Product To Truck Schedule</h3>
<div id="dvAddToTruckSchedule">
    
<p>If product cannot be found in grid below, the product has not been imported from CMS yet. Please select from drop down and add.</p>
<span><input id="cboxCMSProducts" /> 
     <button type="button" id="btnAddProduct" style="vertical-align:bottom" onclick='onClick_AddProduct()'>Add Product</button> 
    <label id="lblAddProduct" style="color:darkgreen"></label>
</span>
</div>
<br /><br />


<h3 onclick="onclick_toggle('#dvAssociateToProduct')" class="Mi4_divButton">Product Associations</h3>
<div id="dvAssociateToProduct">
    <p>Click grid row to select product and associate to different items in their respective grids that will appear after selecting a row.</p>
    <p>Please make sure tanks, spots, and patterns have already been created and are available.</p>
    <div><table id="GridProductAssociations" class="scrollGridClass"></table></div>
</div>

<div id="dvGridItems" style="display:none">
    <div><h3 onclick="onclick_toggle('#dvGridTanks')" class="Mi4_divButton">Associate to Existing Tanks</h3></div>
    <div id="dvGridTanks"><table id="GridTanks" class="scrollGridClass"></table></div>

    <div><h3 onclick="onclick_toggle('#dvGridSpots')" class="Mi4_divButton">Associate to Existing Spots</h3></div>
    <div id="dvGridSpots"><table id="GridSpots" class="scrollGridClass"></table></div>

    <div><h3 onclick="onclick_toggle('#dvGridPatterns')" class="Mi4_divButton">Associate to Existing Patterns</h3></div>
    <div id="dvGridPatterns"><table id="GridPatterns" class="scrollGridClass"></table></div>

    <div><h3 onclick="onclick_toggle('#GridInspectionLists')" class="Mi4_divButton">Associate to Existing Inspections List</h3></div>
    <div id="GridInspectionLists"><table id="GridInspections" class="scrollGridClass"></table></div>
    <br />
    <br />
    <br />
    <br />
</div>
    
</asp:Content>
