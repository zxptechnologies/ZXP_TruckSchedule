<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_CustomerVendorProducts.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_CustomerVendorProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_GRID_DATA = [];
        var GLOBAL_CUSTOMERID = 0;
        var GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS = [];
        var GLOBAL_FULL_CUSTOMER_LIST = [];
        var GLOBAL_GRID_EXIST = false;
        var GLOBAL_PRODUCT_OPTIONS = [];
        var GLOBAL_CURRENT_CUSTOMER = null;
        var GLOBAL_PRODUCT_NAME_OPTIONS = [];
        var GLOBAL_PRODUCT_ID_OPTIONS = [];
        var FILTERTEXTID = "";
        var FILTERTEXTNAME = "";
        var FILTERTEXT = "";


        <%-------------------------------------------------------
        Pagemethods Handlers
        -----------------------------------------------------------%>

        function onSuccess_getFirsBatchOfCustomers(value, ctx, methodName) {
            GLOBAL_FULL_CUSTOMER_LIST = [];
            if (value != null) {
                for (i = 0; i < value.length; i++) {
                    var custNameWithID = value[i][1].trim() + " - " + value[i][0].trim();
                    <%--ABOVE: Names are duplicated in CMS so BVCUST has been added to help keep things unique--%>
                    GLOBAL_FULL_CUSTOMER_LIST[i] = {
                        "CUSTOMERID": value[i][0], "CUSTOMERNAME": custNameWithID
                    };
                }
            }
            PageMethods.getCustomersWithProductsList(onSuccess_getCustomersWithProductsList, onFail_getCustomersWithProductsList);
        }

        function onFail_getFirsBatchOfCustomers(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getFirsBatchOfCustomers");
        }

        function onSuccess_getCustomersWithProductsList(value, ctx, methodName) {//asd
            var newIndex = 1;
            for (var i = 0; i < value.length; i++) {
                var custNameWithID = value[i][1].trim() + " - " + value[i][0].trim();
                GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[i + 1] = { "CUSTOMERID": value[i][0], "CUSTOMERNAME": custNameWithID };
            }
            GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[0] = { "CUSTOMERID": "NewCustomerProduct", "CUSTOMERNAME": "ADD NEW" };

            $("#cboxCustomersWithProductsList").igCombo("option", "dataSource", GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS);
            $("#cboxCustomersWithProductsList").igCombo("dataBind"); //rebind combobox

            PageMethods.getAvailableProducts(onSuccess_getAvailableProducts, onFail_getAvailableProducts);

        }

        function onSuccess_getAvailableProducts2(value, ctx, methodName) {
            GLOBAL_PRODUCT_OPTIONS = [];
            for (i = 0; i < value.length; i++) {
                GLOBAL_PRODUCT_OPTIONS[i] = { "PRODUCT": value[i][0].trim(), "PRODUCTTEXT": value[i][1].trim() };
            }
            $("#cboxProducts").igCombo("dataBind"); //rebind combobox
            initGrid();
            $("#gridCustomerDivWrapper").hide();

        }

        function onSuccess_getAvailableProducts(value, ctx, methodName) {
            GLOBAL_PRODUCT_NAME_OPTIONS = [];
            GLOBAL_PRODUCT_ID_OPTIONS = [];
            for (i = 0; i < value.length; i++) {
                var prodID = value[i][0].trim();
                var prodName = value[i][1].trim();

                if (i < 5) {//todo remove, is used for testing
                    GLOBAL_PRODUCT_ID_OPTIONS.push({ "PRODUCT": value[i][0], "PRODUCTTEXT": prodID });
                    GLOBAL_PRODUCT_NAME_OPTIONS.push({ "PRODUCT": value[i][1], "PRODUCTTEXT": prodName });
                }
            }
            $("#cboxProductsNames").igCombo("dataBind"); //rebind combobox
            $("#cboxProductIDs").igCombo("dataBind"); //rebind combobox
            initGrid();
            $("#gridCustomerDivWrapper").hide();
        }






        function onFail_getAvailableProducts(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getAvailableProducts");
        }

        function onFail_getCustomersWithProductsList(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getCustomersWithProductsList");
        }


        function onSuccess_getProductsByCustomerData(value, ctx, methodName) {
            GLOBAL_GRID_DATA = [];
            if (value != null) {
                $("#gridCustomerDivWrapper").show();
                $("#fullCustomerList").hide();
                
                for (i = 0; i < value.length; i++) {
                    GLOBAL_GRID_DATA[i] = {
                        "CUSTPRODID": value[i][0], "PRODUCTID": value[i][1], "PRODUCTNAME": value[i][2]
                    };

                    var resultName = searchArrayForProductExistence(GLOBAL_PRODUCT_NAME_OPTIONS, value[i][2]);
                    var resultID = searchArrayForProductExistence(GLOBAL_PRODUCT_ID_OPTIONS, value[i][1]);
                    var newProductName = $.trim(value[i][2]);
                    var newProductID = $.trim(value[i][1]);
                    if (resultName != true) {
                        GLOBAL_PRODUCT_NAME_OPTIONS.push({ "PRODUCT": value[i][2], "PRODUCTTEXT": newProductName });
                    }
                    if (resultID != true) {
                        GLOBAL_PRODUCT_ID_OPTIONS.push({ "PRODUCT": value[i][1], "PRODUCTTEXT": newProductID });
                    }

                }

                $("#cboxProductsNames").igCombo('option', 'dataSource', GLOBAL_PRODUCT_NAME_OPTIONS);
                $("#cboxProductsNames").igCombo("dataBind");

                $("#cboxProductsIDs").igCombo('option', 'dataSource', GLOBAL_PRODUCT_ID_OPTIONS);
                $("#cboxProductsIDs").igCombo("dataBind");

                $("#gridCustomer").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
                $("#gridCustomer").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>

                //get product names
                //for (i = 0; i < value.length; i++) {
                //PageMethods.getProductName(value[i][1], onSuccess_getProductNameForGrid, onFail_getProductName, value[i][0]);
                //}

            }
        }

        function onFail_getProductsByCustomerData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getProductsByCustomerData");
        }
        
        function onSuccess_updateProduct(value, ctx, methodName) {
            $("#gridCustomer").igGrid("commit");

        }

        function onFail_updateProduct(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_updateProduct");
        }
        
        function onSuccess_disableProductToCustomer(value, ctx, methodName) {
            $("#gridCustomer").igGridUpdating("deleteRow", ctx);
            $("#gridCustomer").igGrid("commit");
        }

        function onFail_disableProductToCustomer(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_disableProductToCustomer");
        }

        function onSuccess_getProductNameForGrid(value, ctx, methodName) {
            $("#gridCustomer").igGridUpdating("setCellValue", ctx, 'PRODUCTNAME', value.trim());
            $("#gridCustomer").igGrid("commit");
        }
        function onSuccess_getProductNameForCombo(value, ctx, methodName) {
            $("#gridCustomer").igGridUpdating("setCellValue", ctx, 'PRODUCTNAME', value.trim());
            $("#gridCustomer").igGrid("commit");
        }

        function onFail_getProductName(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getProductName");
        }

        function onSuccess_getCustomerListBasedOnInput(value, ctx, methodName) {
            var result;
            if (value.length > 0) {
                for (i = 0; i < value.length; i++) {
                    //result = searchArrayForProductExistence(GLOBAL_PRODUCT_OPTIONS, value[i][0]);
                    //if (result != true) {
                        var custNameWithID = value[i][1].trim() + " - " + value[i][0].trim();
                        GLOBAL_FULL_CUSTOMER_LIST[i] = { "CUSTOMERID": value[i][0], "CUSTOMERNAME": custNameWithID };
                    //}
                }


                $("#cboxFullCustomerList").igCombo("option", "dataSource", GLOBAL_FULL_CUSTOMER_LIST);
                $("#cboxFullCustomerList").igCombo("dataBind"); //rebind combobox

                document.getElementById("cboxFullCustomerList").value = ctx;

                //$("#cboxFullCustomerList").igCombo("option", "dataSource", GLOBAL_FULL_CUSTOMER_LIST);

                //$("#grid").igGridUpdating("setCellValue", ctx, "PRODUCT", value.trim());
            }
        }

        function onFail_getCustomerListBasedOnInput(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getCustomerListBasedOnInput");
        }

        function onSuccess_setNewProductToCustomer(value, custProdID, methodName) {
            var isNewCustomer = $("#cboxCustomersWithProductsList").data("data-isNewCustomer");
            if(isNewCustomer === true)
            {
                //GLOBAL_CUSTOMERID = ui.items[0].data.CUSTOMERID;
                //GLOBAL_CURRENT_CUSTOMER = ui.items[0].data.CUSTOMERNAME;
                var customerID = $("#cboxCustomersWithProductsList").data("data-newCustomerID");
                var customerName = $("#cboxCustomersWithProductsList").val();
                GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.shift();
                GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.unshift({ "CUSTOMERID": customerID, "CUSTOMERNAME": customerName });
                GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.unshift({ "CUSTOMERID": "NewCustomerProduct", "CUSTOMERNAME": "ADD NEW" });
                $("#cboxCustomersWithProductsList").igCombo("value", customerID);
                $("#cboxCustomersWithProductsList").data("data-isNewCustomer", false);
                $("#cboxCustomersWithProductsList").data("data-newCustomerID", 0);
                $("#btn_cancelNewCustomer").hide();
            }



            $("#gridCustomer").igGridUpdating("setCellValue", custProdID, 'CUSTPRODID', value);
            $("#gridCustomer").igGrid("commit");
           
        }

        function onFail_setNewProductToCustomer(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_setNewProductToCustomer");
        }



        function onSuccess_getProductNameByID(value, ctx, methodName) {
            if (value != null) {
                var result = searchArrayForProductExistence(GLOBAL_PRODUCT_NAME_OPTIONS, value);
                var newName = $.trim(value);
                if (result != true) {
                    GLOBAL_PRODUCT_NAME_OPTIONS.push({ "PRODUCT": value[i], "PRODUCTTEXT": newName });
                    $("#cboxProductsNames").igCombo('option', 'dataSource', GLOBAL_PRODUCT_NAME_OPTIONS);
                    $("#cboxProductsNames").igCombo("dataBind");
                    //$("#cboxProductsNames").val(value);
                    //var tempIndexCheck = GLOBAL_PRODUCT_NAME_OPTIONS.length - 1;
                    //$("#cboxProductNames").igCombo("selectedIndex", tempIndexCheck);
                }
                else {
                    var myItem = $("#cbocProductIDs").igCombo("itemByValue", value);
                    //alert(myItem.index);
                    //$("#cboxProductNames").igCombo("value", value[i]);
                    $("#cboxProductNames").igCombo("text", newName); //old way? not sure why I was doing this - AJ
                }
                //$("#cboxProductNames").igCombo("value", value[0]);
                $("#cboxProductNames").igCombo("text", newName); //old way? not sure why I was doing this - AJ
            }
        }

        function onFail_getProductNameByID(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getProductNameByID");
        }

        function onSuccess_getProductIDByName(value, ctx, methodName) {
            var result = false;
            var newName = null;
            var fullProdID = null;
            if (value != null) {
                for (var i = 0; i < value.length; i++) {
                    result = searchArrayForProductExistence(GLOBAL_PRODUCT_ID_OPTIONS, value[i]);
                    newName = $.trim(value[i]);
                    if (result != true) {
                        GLOBAL_PRODUCT_ID_OPTIONS.push({ "PRODUCT": value[i], "PRODUCTTEXT": newName });
                        $("#cboxProductIDs").igCombo('option', 'dataSource', GLOBAL_PRODUCT_ID_OPTIONS);
                        $("#cboxProductIDs").igCombo("dataBind");
                    }
                    else {
                       // $("#cboxProductIDs").igCombo("value", value[i]);
                        //var myItem = $("#cbocProductIDs").igCombo("itemByValue", value);
                       $("#cboxProductIDs").igCombo("text", newName);
                    }
                }

               // $("#cboxProductIDs").igCombo("value", value[0]);
                //var comboEditor = $("#gridCustomer").igGridUpdating("editorForKey", "PRODUCTNAME");
               // comboEditor.igCombo("text", ctx);

                $("#cboxProductIDs").igCombo("text", newName);
            }
        }

        function onFail_getProductIDByName(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getProductIDByName");
        }

        function onSuccess_getProductIDsListBasedOnInput(value, ctx, methodName) {
            var resultID = true;
            var resultName = true;
            if (value.length > 0) {
                for (i = 0; i < value.length; i++) {
                    resultID = searchArrayForProductExistence(GLOBAL_PRODUCT_ID_OPTIONS, value[i][0]);
                    resultName = searchArrayForProductExistence(GLOBAL_PRODUCT_NAME_OPTIONS, value[i][0]);

                    var prodID = value[i][0].trim();
                    var prodName = value[i][1].trim();
                    if (resultID != true) {
                        GLOBAL_PRODUCT_ID_OPTIONS.push({ "PRODUCT": value[i][0], "PRODUCTTEXT": prodID });
                    }
                    if (resultName != true) {
                        GLOBAL_PRODUCT_NAME_OPTIONS.push({ "PRODUCT": value[i][0], "PRODUCTTEXT": prodName });
                    }
                }
                $("#cboxProductIDs").igCombo('option', 'dataSource', GLOBAL_PRODUCT_ID_OPTIONS);
                $("#cboxProductNames").igCombo('option', 'dataSource', GLOBAL_PRODUCT_NAME_OPTIONS);
                $("#cboxProductIDs").igCombo("dataBind");
                $("#cboxProductNames").igCombo("dataBind");
                var comboEditor = $("#gridCustomer").igGridUpdating("editorForKey", "PRODUCTID");
                comboEditor.igCombo("text", ctx);
            }
        }

        function onSuccess_getProductNamesListBasedOnInput(value, ctx, methodName) {
            var resultID = true;
            var resultName = true;
            if (value.length > 0) {
                for (i = 0; i < value.length; i++) {
                    resultID = searchArrayForProductExistence(GLOBAL_PRODUCT_ID_OPTIONS, value[i][0]);
                    resultName = searchArrayForProductExistence(GLOBAL_PRODUCT_NAME_OPTIONS, value[i][1]);

                    if (resultID != true) {
                        var prodID = value[i][0].trim();
                        GLOBAL_PRODUCT_ID_OPTIONS.push({ "PRODUCT": value[i][0], "PRODUCTTEXT": prodID });
                        resultID = true;
                    }
                    if (resultName != true) {
                        var prodName = value[i][1].trim();
                        GLOBAL_PRODUCT_NAME_OPTIONS.push({ "PRODUCT": value[i][0], "PRODUCTTEXT": prodName });
                        resultName = true;
                    }
                }
                $("#cboxProductIDs").igCombo('option', 'dataSource', GLOBAL_PRODUCT_ID_OPTIONS);
                $("#cboxProductNames").igCombo('option', 'dataSource', GLOBAL_PRODUCT_NAME_OPTIONS);
                $("#cboxProductIDs").igCombo("dataBind");
                $("#cboxProductNames").igCombo("dataBind");
                var comboEditor = $("#gridCustomer").igGridUpdating("editorForKey", "PRODUCTNAME");
                comboEditor.igCombo("text", ctx);
            }
        }

        function onFail_getProductListBasedOnInput(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_getProductListBasedOnInput");
        }


        function onSuccess_disableCustomer(value, ctx, methodName) {
            for (var i = 0; i < GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.length; i++) {
                if (GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[i].CUSTOMERID == ctx) {
                    GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.splice(i, 1);
                    $("#cboxCustomersWithProductsList").igCombo("option", "dataSource", GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS);
                    $("#cboxCustomersWithProductsList").igCombo("dataBind"); //rebind combobox
                    GLOBAL_GRID_DATA = [];
                    $("#gridCustomer").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
                    $("#gridCustomer").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
                    $("#gridCustomerDivWrapper").hide(); 
                    $("#btn_removeCustomer").hide();
                    break;
                }
            }

        }

        function onFail_disableCustomer(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CustomerVendorProducts.aspx, onFail_disableCustomer");
        }
        <%-------------------------------------------------------
        Other methods
        -----------------------------------------------------------%>

        function checkIfCustomerListExist(selectedCustomerID) {
            for (var i = 0; i < GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.length; i++) {
                if (selectedCustomerID == GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[i].CUSTOMERID) {
                    return true;
                }
            }
            return false;
        }
            function formatProducts(val) {
                var i, prod;
                for (i = 0; i < GLOBAL_PRODUCT_OPTIONS.length; i++) {
                    prod = GLOBAL_PRODUCT_OPTIONS[i];
                    if (prod.PRODUCT == val) { val = prod.PRODUCTTEXT; }
                }
                return val;
            }

            function onClick_cancelNewCustomerAdd() {
                GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.shift();
                GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.unshift({ "CUSTOMERID": "NewCustomerProduct", "CUSTOMERNAME": "ADD NEW" });
                $("#cboxCustomersWithProductsList").igCombo("dataBind");
                $("#btn_cancelNewCustomer").hide();
                $("#gridCustomerDivWrapper").hide();
            }

            function onClick_removeCustomer() {
                var customerName = null;
                var customerID = $("#cboxCustomersWithProductsList").igCombo("value");
                for (var i = 0; i < GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.length; i++)
                {
                    if (GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[i].CUSTOMERID == customerID) {
                        customerName = GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[i].CUSTOMERNAME;
                        break;
                    }
                }
                var c = confirm("You are about to delete " + customerName + ". This can not be undone.");
                if (c == true) {
                    PageMethods.disableCustomer(customerID, onSuccess_disableCustomer, onFail_disableCustomer, customerID);
                    return false;
                }
                else {
                    return false;
                }
            }
            function checkIfProductExsist(productID) {
                for (var index = 0; index < GLOBAL_GRID_DATA.length ; index++) {
                    if (GLOBAL_GRID_DATA[index].PRODUCTID == productID) {
                        return index;
                    }
                }
            }

                $(function () {
                    //$("#cboxProductNames").change(function () {
                    //    alert("Eureka");
                    //});
                    $("#cboxCustomersWithProductsList").text("placeholder", "testing....");
                    $("#fullCustomerList").hide();
                    $("#btn_removeCustomer").hide();
                    $("#btn_cancelNewCustomer").hide();
                    $("#removeVendor").hide();
                    PageMethods.getFirsBatchOfCustomers(onSuccess_getFirsBatchOfCustomers, onFail_getFirsBatchOfCustomers);

                    $("#cboxCustomersWithProductsList").igCombo({
                        dataSource: null,
                        textKey: "CUSTOMERNAME",
                        valueKey: "CUSTOMERID",
                        width: "400px",
                        virtualization: true,
                        selectionChanged:  function (evt, ui) {
                            if (ui.items.length == 1) {
                                GLOBAL_CUSTOMERID = ui.items[0].data.CUSTOMERID;
                                GLOBAL_CURRENT_CUSTOMER = ui.items[0].data.CUSTOMERNAME;
                                if ((ui.items[0].data.CUSTOMERID == "NewCustomerProduct") && (evt.originalEvent.type == 'mouseup' || evt.originalEvent.type == 'keyup')) {
                                    $("#btn_removeCustomer").hide();
                                    $("#btn_cancelNewCustomer").hide();
                                    $("#fullCustomerList").show();
                                    $("#gridCustomerDivWrapper").hide();
                                    $("#cboxFullCustomerList").igCombo("option", "dataSource", GLOBAL_FULL_CUSTOMER_LIST);
                                    $("#cboxFullCustomerList").igCombo("dataBind"); //rebind combobox
                                }
                                else if (ui.items[0].data.CUSTOMERID == "aNewCustomer") {
                                    $("#btn_removeCustomer").hide();
                                    $("#btn_cancelNewCustomer").show();
                                    GLOBAL_GRID_DATA = [];
                                    $("#gridCustomer").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
                                    $("#gridCustomer").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
                                    $("#gridCustomerDivWrapper").show();
                                }
                                else if (evt.originalEvent.type == 'mouseup' || evt.originalEvent.type == 'keydown') {
                                    $("#btn_removeCustomer").show();
                                    $("#btn_cancelNewCustomer").hide();
                                    PageMethods.getProductsByCustomerData(GLOBAL_CUSTOMERID, onSuccess_getProductsByCustomerData, onFail_getProductsByCustomerData);
                                }
                            }
                            else if (ui.items.length == 0) {
                                GLOBAL_GRID_DATA = [];
                                $("#gridCustomer").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
                                $("#gridCustomer").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
                                $("#gridCustomerDivWrapper").hide();
                                $("#btn_cancelNewCustomer").hide();
                                $("#btn_removeCustomer").hide();
                            }
                        }
                    });
            
                    $("#cboxFullCustomerList").igCombo({
                        dataSource: null,
                        textKey: "CUSTOMERNAME",
                        valueKey: "CUSTOMERID",
                        width: "400px",
                        nullText: "Please enter the customer name...",
                        loadOnDemandSettings: {enabled: true},
                        filtering: function (evt, ui) {
                            var cBoxCustInput = $("#cboxFullCustomerList").val();
                            var cBoxCustLength = cBoxCustInput.length;
                            if (cBoxCustLength >= 3 && FILTERTEXT.length < 2) {
                                FILTERTEXT = cBoxCustInput;
                                PageMethods.getCustomerListBasedOnInput(cBoxCustInput, onSuccess_getCustomerListBasedOnInput, onFail_getCustomerListBasedOnInput, cBoxCustInput);
                            }
                            else if (cBoxCustLength >= 3 && FILTERTEXT.length >= 3) {
                                FILTERTEXT = FILTERTEXT.substring(0, cBoxCustLength)
                                if (FILTERTEXT != cBoxCustInput) {
                                    FILTERTEXT = cBoxCustInput;
                                    PageMethods.getCustomerListBasedOnInput(cBoxCustInput, onSuccess_getCustomerListBasedOnInput, onFail_getCustomerListBasedOnInput, cBoxCustInput);
                                }
                            }
                        },
                        selectionChanged: function (evt, ui) {
                            if (ui.items.length == 1) {<%--makes sure a customer is select (without this, it will sometimes trigger this method while filtering)--%>
                                var existingCustomer = false;
                                var custID = ui.items[0].data.CUSTOMERID;
                                if (evt.originalEvent.type == 'mouseup' || evt.originalEvent.type == 'keydown') {<%--checks event type...duh?--%>
                                    for (var i = 0; i < GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.length; i++) {
                                        if (GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[i].CUSTOMERID.trim() == custID.trim())
                                        {
                                            existingCustomer = true;
                                            break;
                                        }
                                    }
                                    if (existingCustomer == false) {
                                        $("#cboxCustomersWithProductsList").data("data-isNewCustomer", true);
                                        $("#cboxCustomersWithProductsList").data("data-newCustomerID", custID);
                                        GLOBAL_CUSTOMERID = ui.items[0].data.CUSTOMERID;
                                        GLOBAL_CURRENT_CUSTOMER = ui.items[0].data.CUSTOMERNAME;
                                        GLOBAL_GRID_DATA = [];
                                        $("#gridCustomer").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
                                        $("#gridCustomer").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
                                        //$("#cboxCustomersWithProductsList")
                                        GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.shift();
                                        GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.unshift({ "CUSTOMERID": "aNewCustomer", "CUSTOMERNAME": ui.items[0].data.CUSTOMERNAME });
                                        $("#cboxCustomersWithProductsList").igCombo("option", "dataSource", GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS);
                                        $("#cboxCustomersWithProductsList").igCombo("dataBind"); //rebind combobox
                                        $("#cboxCustomersWithProductsList").igCombo("value", "aNewCustomer");
                                        $("#btn_cancelNewCustomer").show();
                                        $("#gridCustomerDivWrapper").show();
                                        $("#fullCustomerList").hide();
                                    }
                                    else {//todo set cboxCustomersWithProductsList to choosen custID
                                        //$("#cboxCustomersWithProductsList").igCombo("selectedIndex", custID);
                                        GLOBAL_CUSTOMERID = custID.trim();
                                        $("#cboxCustomersWithProductsList").igCombo("value", GLOBAL_CUSTOMERID);
                                        $("#gridCustomerDivWrapper").show(); 
                                        $("#btn_removeCustomer").show();
                                        PageMethods.getProductsByCustomerData(GLOBAL_CUSTOMERID, onSuccess_getProductsByCustomerData, onFail_getProductsByCustomerData);

                                    }
                                }
                            }
                            else if (ui.items.length == 0) {
                                GLOBAL_GRID_DATA = [];
                                $("#gridCustomer").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
                                $("#gridCustomer").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
                                $("#gridCustomerDivWrapper").hide();

                            }
                        }
                    });

                });

                function initGrid() {
                    $("#gridCustomer").igGrid({
                        dataSource: GLOBAL_GRID_DATA,
                        width: "99%",
                        autoGenerateColumns: true,
                        renderCheckboxes: true,
                        autoComplete: true,
                        primaryKey: "CUSTPRODID",
                        columns:
                            [
                                { headerText: "Part Number", key: "PRODUCTID", dataType: "string", width: "25%" },
                                { headerText: "Product Name", key: "PRODUCTNAME", dataType: "string", width: "75%" },
                                { headerText: "", key: "CUSTPRODID", dataType: "number", hidden: true }
                                <%--above: primary key needs to be unique, DB was using combo of product id & product name --%>
                            ],
                        features: [
                            {
                                name: 'Resizing'
                            },
                            {
                                name: "Filtering",
                                allowFiltering: true,
                                caseSensitive: false
                            },
                            {
                                name: 'Sorting'
                            },
                            {
                                name: 'Updating',
                                enableAddRow: true,
                                editMode: 'row',
                                enableDeleteRow: true,
                                showReadonlyEditors: false,
                                enableDataDirtyException: false,
                                autoCommit: false,
                                editRowStarting: function (evt, ui) {
                                    if (!ui.rowAdding) {
                                        var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                        $("#gridCustomer").data("data-CUSTPRODID", row.CUSTPRODID);
                                    }
                                    else {
                                        $("#gridCustomer").data("data-CUSTPRODID", 0);
                                    }
                                },
                                rowDeleting: function (evt, ui) {
                                    var prodName = $("#gridCustomer").igGrid("getCellValue", ui.rowID, "PRODUCTNAME");
                                    var c = confirm("Continue deleting request for " + prodName.trim() + "? Deletion cannot be undone.");
                                    if (c == true) {
                                        PageMethods.disableProductToCustomer(ui.rowID, onSuccess_disableProductToCustomer, onFail_disableProductToCustomer, ui.rowID);
                                        return false;
                                    }
                                    else {
                                        return false;
                                    }
                                    //return false;
                                },
                                editRowEnding: function (evt, ui) {
                                    if (ui.update == true && ui.rowAdding == true && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                                        //var orgCustomerName = GLOBAL_CURRENT_CUSTOMER.substring(0, GLOBAL_CURRENT_CUSTOMER.indexOf(' - ' + GLOBAL_CUSTOMERID));
                                        var isNewCustomer = $("#cboxCustomersWithProductsList").data("data-isNewCustomer");
                                        <%--the following gets the current customer--%>
                                        if (isNewCustomer == true) {
                                            var customerID = $("#cboxCustomersWithProductsList").data("data-newCustomerID");
                                            PageMethods.setNewProductToCustomer(customerID, ui.values.PRODUCTID,
                                                                                onSuccess_setNewProductToCustomer, onFail_setNewProductToCustomer, ui.values.CUSTPRODID);
                                        }
                                        else {
                                            var exsistingProdIndex = checkIfProductExsist(ui.values.PRODUCTID); //function to checks to see if product exsist with customer
                                            if (checkNullOrUndefined(exsistingProdIndex) == true) {// if it doesnt, proceed
                                                var selelctedCustomerID = GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[
                                                    GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.map(function (e) { return e.CUSTOMERNAME }).indexOf($("#cboxCustomersWithProductsList").val())].CUSTOMERID;


                                                PageMethods.setNewProductToCustomer(selelctedCustomerID, ui.values.PRODUCTID,
                                                                                    onSuccess_setNewProductToCustomer, onFail_setNewProductToCustomer, ui.values.CUSTPRODID);
                                            }
                                            else {//else dont allow add
                                                alert(ui.values.PRODUCTID.trim() + " already has an association to this customer");
                                                ui.keepEditing = true;
                                                return false;
                                            }
                                        }

                                    }
                                    else if (ui.update == true && ui.rowAdding == false && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                                        var exsistingProdIndex = checkIfProductExsist(ui.values.PRODUCTID); //function to checks to see if product exsist with customer
                                        if (checkNullOrUndefined(exsistingProdIndex) == false) {
                                            if (GLOBAL_GRID_DATA[exsistingProdIndex].CUSTPRODID == ui.rowID) { //if it doesnt or if it does but its the one currently being editted, proceed
                                                var selelctedCustomerID = GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[
                                                        GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.map(function (e) { return e.CUSTOMERNAME }).indexOf($("#cboxCustomersWithProductsList").val())].CUSTOMERID;
                                                PageMethods.updateProduct(ui.rowID, ui.values.PRODUCTID, selelctedCustomerID, onSuccess_updateProduct, onFail_updateProduct);
                                            }
                                            else {//else alert and do not allow edit
                                                alert(ui.values.PRODUCTID.trim() + " already has an association to this customer");
                                                ui.keepEditing = true;
                                                return false;
                                            }
                                        }
                                        else {//else alert and do not allow edit
                                            var selelctedCustomerID = GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS[
                                                    GLOBAL_CUSTOMER_WITH_PRODUCTS_OPTIONS.map(function (e) { return e.CUSTOMERNAME }).indexOf($("#cboxCustomersWithProductsList").val())].CUSTOMERID;
                                            PageMethods.updateProduct(ui.rowID, ui.values.PRODUCTID, selelctedCustomerID, onSuccess_updateProduct, onFail_updateProduct);
                                        }

                                    }

                                },
                                columnSettings:
                                    [
                                         {
                                             //columnKey: "PRODUCTNAME",
                                             //editorType: "combo",
                                             ////required: true,
                                             //editorOptions: {
                                             //    virtualization: true,
                                             //    mode: "editable",
                                             //    dataSource: GLOBAL_PRODUCT_NAME_OPTIONS,
                                             //    id: "cboxProductNames",
                                             //    textKey: "PRODUCTTEXT",
                                             //    valueKey: "PRODUCT",
                                             columnKey: "PRODUCTNAME",
                                             editorType: "combo",
                                             //required: true,
                                             editorOptions: {
                                                 virtualization: true,
                                                 mode: "editable",
                                                 dataSource: GLOBAL_PRODUCT_NAME_OPTIONS,
                                                 id: "cboxProductNames",
                                                 textKey: "PRODUCTTEXT",
                                                 valueKey: "PRODUCT",
                                                 filtering: function (evt, ui) {
                                                     var cBoxProdInput = $(evt.currentTarget).attr("value");
                                                     var cBoxProdLength = cBoxProdInput.length;

                                                     if (cBoxProdLength >= 3 && FILTERTEXTNAME.length < 2) {
                                                         FILTERTEXTNAME = cBoxProdInput;
                                                         GLOBAL_ROWID = ui.rowID;
                                                         PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductNamesListBasedOnInput, onFail_getProductListBasedOnInput,
                                                                                                  cBoxProdInput);
                                                     }
                                                     else if (cBoxProdLength >= 3 && FILTERTEXTNAME.length >= 3) {
                                                         FILTERTEXTNAME = FILTERTEXTNAME.substring(0, cBoxProdLength)
                                                         if (FILTERTEXTNAME != cBoxProdInput) {
                                                             FILTERTEXTNAME = cBoxProdInput;
                                                             GLOBAL_ROWID = ui.rowID;
                                                             PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductNamesListBasedOnInput, onFail_getProductListBasedOnInput, cBoxProdInput);
                                                         }
                                                     }
                                                 },
                                                 selectionChanged: function (evt, ui) {
                                                     if (ui.items.length > 0) {
                                                         PageMethods.getProductIDByName(ui.items[0].data.PRODUCT, onSuccess_getProductIDByName, onFail_getProductIDByName, ui.items[0].data.PRODUCT);
                                                     }
                                                     else if (ui.items.length == 0) {
                                                         var comboEditor = $("#gridCustomer").igGridUpdating("editorForKey", "PRODUCTID");
                                                         comboEditor.igCombo("text", "");

                                                     }
                                                 }

                                             }
                                         },
                                         {
                                             columnKey: "PRODUCTID",
                                             editorType: "combo",
                                             //required: true,
                                             editorOptions: {
                                                 virtualization: true,
                                                 mode: "editable",
                                                 dataSource: GLOBAL_PRODUCT_ID_OPTIONS,
                                                 id: "cboxProductIDs",
                                                 textKey: "PRODUCTTEXT",
                                                 valueKey: "PRODUCT",
                                                 filtering: function (evt, ui) {
                                                     var cBoxProdInput = $(evt.currentTarget).attr("value");
                                                     var cBoxProdLength = cBoxProdInput.length;

                                                     if (cBoxProdLength >= 3 && FILTERTEXTID.length < 2) {
                                                         FILTERTEXTID = cBoxProdInput;
                                                         GLOBAL_ROWID = ui.rowID;
                                                         PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductIDsListBasedOnInput, onFail_getProductListBasedOnInput,
                                                                                                  cBoxProdInput);
                                                     }
                                                     else if (cBoxProdLength >= 3 && FILTERTEXTID.length >= 3) {
                                                         FILTERTEXTID = FILTERTEXTID.substring(0, cBoxProdLength)
                                                         if (FILTERTEXTID != cBoxProdInput) {
                                                             FILTERTEXTID = cBoxProdInput;
                                                             GLOBAL_ROWID = ui.rowID;
                                                             PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductIDsListBasedOnInput, onFail_getProductListBasedOnInput, cBoxProdInput);
                                                         }
                                                     }
                                                 },
                                                 selectionChanged: function (evt, ui) {
                                                     if (ui.items.length > 0) {
                                                         PageMethods.getProductNameByID(ui.items[0].data.PRODUCT, onSuccess_getProductNameByID, onFail_getProductNameByID, ui.items[0].data.PRODUCT);
                                                     }
                                                     else if (ui.items.length == 0) {
                                                         var comboEditor = $("#gridCustomer").igGridUpdating("editorForKey", "PRODUCTNAME");
                                                         comboEditor.igCombo("text", "");

                                                     }
                                                 }
                                             }
                                         }
                                    ]
                            }
                        ]
                    }); <%--end of $("#gridCustomerCustomer").igGrid({--%>
                    GLOBAL_GRID_EXIST = true;
                };
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
        

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    
    <div>
        <h1>Select a Customer</h1>
        <input id="cboxCustomersWithProductsList" />
        <button type="button" id="btn_removeCustomer" onclick="onClick_removeCustomer()">Remove Customer</button>
        <button type="button" id="btn_cancelNewCustomer" onclick="onClick_cancelNewCustomerAdd()">Cancel New Customer Add</button>
    </div>

    <div id ="fullCustomerList">
        <h1>Add a New Customer</h1>
        <input id="cboxFullCustomerList" />
    </div>
    

    <div id="gridCustomerDivWrapper"><table id="gridCustomer"></table></div>



</asp:Content>