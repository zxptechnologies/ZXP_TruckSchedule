
function InitInspectionQuestionOnclick () {

    $(".up_nav").on("click", function () {
        var questionNum = $("#tblQuestions").data("questNum");
        if (questionNum > 1) {

            $("#trQuestion" + questionNum).hide();
            $("#trQuestion" + (questionNum - 1)).show();
            $("#tblQuestions").data("questNum", questionNum - 1);
        }
        return false;
    });

    $(".down_nav").on("click", function () {
        var rowCount = $('#tblQuestions tr').length;
        var questionNum = $("#tblQuestions").data("questNum");
        var isChecked = $("input:radio[name='rd_Questions" + questionNum + "']").is(":checked")
        if (!isChecked) {
            alert("Please select an answer before continuing to the next question.");
            return false;
        }
        if (questionNum < rowCount) {
            $("#trQuestion" + questionNum).hide();
            $("#trQuestion" + (questionNum + 1)).show();
            $("#tblQuestions").data("questNum", questionNum + 1);
        }
        return false;
    });
}



function setTestResult(testID, MSInspectionID, inspectionQuestionObjIndex, result, clickedItem) {
         
    $("input:radio[name=" + clickedItem[0].name + "]").prop("checked", false);
    $("input:radio[name=" + clickedItem[0].name + "]").removeAttr("checked");
    clickedItem.prop("checked", true);
    clickedItem.attr("checked", true);

    //showProgress();

    var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
    var selectedProdDetailID = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "PODetailsID");
   // var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
    var questionNumber = clickedItem[0].id.substr(0, clickedItem[0].id.indexOf('_'));

    switch (result) {
        case 0:
            $("#" + questionNumber + "_1").parent().css("background-color", "#ffffff");
            $("#" + questionNumber + "_-1").parent().css("background-color", "#ffffff");
            $("#" + questionNumber + "_0").parent().css("background-color", "#33cc33");
            break;
        case 1:
            $("#" + questionNumber + "_0").parent().css("background-color", "#ffffff");
            $("#" + questionNumber + "_-1").parent().css("background-color", "#ffffff");
            $("#" + questionNumber + "_1").parent().css("background-color", "#33cc33");
            break;
        case -1:
            $("#" + questionNumber + "_0").parent().css("background-color", "#ffffff");
            $("#" + questionNumber + "_1").parent().css("background-color", "#ffffff");
            $("#" + questionNumber + "_-1").parent().css("background-color", "#33cc33");
            break;
    }
    PageMethods.setInspectionResult(MSInspectionID, testID, result, selectedProdDetailID, onSuccess_setInspectionResult, onFail_setInspectionResult);
}

function createQuestionsTable(inspectionQuestions) {
    var newHtmlToAppend = "<table id=\"tblQuestions\" style=\"width:100%; height:80%\" data-questNum=\"1\">";

    for (i = 0; i < inspectionQuestions.length; i++) {
        var questionNum = i + 1;
        var tdContentHTML = "<div align=\"left\">" + inspectionQuestions[i].TestDescription + "</div><div align=\"left\" id=\"dv_rad" + questionNum + "\">\</div>";

        newHtmlToAppend = newHtmlToAppend + "<tr id=\"trQuestion" + questionNum + "\" style=\"width:100%; height:100%; display: none;\" data-TestID=\"" + inspectionQuestions[i].TestID + "\" data-isDealBreaker=\"" + inspectionQuestions[i].isDealBreaker +
            "\"data-Result=\"" + inspectionQuestions[i].Result + "\" ><td class=\"inspectionquestions\"><div align=\"center\">" + tdContentHTML + "</div></td></tr>"

    }

    newHtmlToAppend = newHtmlToAppend + "</table>";

    $("#dvQuestionsArea").append(newHtmlToAppend);

}

function createQuestionDivContent(inspectionQuestions, MSInspectionID) {
    for (i = 0; i < inspectionQuestions.length; i++) {
        var questionNum = i + 1;

        var testID = inspectionQuestions[i].TestID;
        var checkedNA = "";
        var checkedPASS = "";
        var checkedFAIL = "";

        var styleNA = "";
        var stylePASS = "";
        var styleFAIL = "";

        var styleNA2 = "";
        var stylePASS2 = "";
        var styleFAIL2 = "";
        switch (inspectionQuestions[i].Result) {
            case -1: checkedNA = "checked=\"checked\""; styleNA = "style=\"background-color:#33cc33\""; styleNA2 = "style=\"font-weight: bolder\""; break;
            case 0: checkedFAIL = "checked=\"checked\""; styleFAIL = "style=\"background-color:#33cc33\""; styleFAIL2 = "style=\"font-weight: bolder\""; break;
            case 1: checkedPASS = "checked=\"checked\""; stylePASS = "style=\"background-color:#33cc33\""; stylePASS2 = "style=\"font-weight: bolder\""; break;
            default: break;
        }


        var radioButtonPASS = "</br><div " + stylePASS + "><input id=\"" + i + "_" + 1 + "\"" + stylePASS2 + " class=\"mi4-editInspection rad_question\"" + checkedPASS + "  onclick=\"setTestResult(" + testID + "," + MSInspectionID + "," + i + "," + 1 + ",$(this));\" type=\"radio\" name=\"rd_Questions" + questionNum + "\" value=\"1\" data-TestID=\"" + testID + "\"> PASS</div>";

        var radioButtonFAIL = "</br><div " + styleFAIL + "><input id=\"" + i + "_" + 0 + "\"" + styleFAIL2 + " class=\"mi4-editInspection rad_question\"" + checkedFAIL + "  onclick=\"setTestResult(" + testID + "," + MSInspectionID + "," + i + "," + 0 + ",$(this)); \" type=\"radio\" name=\"rd_Questions" + questionNum + "\" value=\"0\" data-TestID=\"" + testID + "\"> FAIL</div>";

        var radioButtonNA = "</br><div " + styleNA + "><input id=\"" + i + "_" + -1 + "\"" + styleNA2 + " class=\"mi4-editInspection rad_question\"" + checkedNA + " onclick=\"setTestResult(" + testID + "," + MSInspectionID + "," + i + "," + -1 + ",$(this)); \" type=\"radio\" name=\"rd_Questions" + questionNum + "\" value=\"-1\" data-TestID=\"" + testID + "\"> N/A</div>";

        var dvName = "#dv_rad" + questionNum;
        $(dvName).append(radioButtonPASS).append(radioButtonFAIL).append(radioButtonNA);

    }
}

function createQuestionsAreaHTML(inspectionQuestions, MSInspectionID) {
    $("#dvQuestionsArea").empty();
    if (inspectionQuestions.length > 0) {
        createQuestionsTable(inspectionQuestions);
        createQuestionDivContent(inspectionQuestions, MSInspectionID);
    }
}


function populateQuestions(MSInspectionListDetailID, functionToReturnData) {
    var InspectionListData = functionToReturnData();
    var inspectionQuestions = null;
    var MSInspectionID = null;
    for (i = 0; i < InspectionListData.InspectionListDetails.length; i++) {
        //   MSInspection = returnItemFromArray(InspectionListData.InspectionListDetails[i], "MSInspectionListDetailID", MSInspectionListDetailID, "MSInspection");

        if (InspectionListData.InspectionListDetails[i].MSInspectionListDetailsID === MSInspectionListDetailID) {
            inspectionQuestions = InspectionListData.InspectionListDetails[i].MSInspection.questions;
        }
        if (inspectionQuestions) {
            MSInspectionID = InspectionListData.InspectionListDetails[i].MSInspection.MSInspectionID;
            break;
        }
    }
    if (inspectionQuestions) {
        createQuestionsAreaHTML(inspectionQuestions, MSInspectionID);
        $("#trQuestion1").show();
    }
}

function populateQuestionsFromInspectionObject(MSInspection) {
    // Retrieve the object from storage
    var inspectionObj = localStorage.getItem('InspectionListObject');
    inspectionObj.InspectionListDetails.forEach(
        function (inspectionDetail) {
            $("#dvButtons").append(getHTMLStringForInspections(inspectionDetail.MSInspection));
        });
    inspectionQuestions = inspectionObj.questions;
    if (inspectionQuestions) {
        MSInspectionID = InspectionListData.InspectionListDetails[i].MSInspection.MSInspectionID;
        createQuestionsAreaHTML(inspectionQuestions, MSInspectionID);
        $("#trQuestion1").show();
    }
}

function onSuccess_setInspectionResult(value, ctx, method) {
    if (value) {
        //var timestamp = value[0];
        var rMsg = value[1];
        var hasEnded = value[2];
        var isLastQuestion = value[3];

        hideProgress();

        var checkNeedsClose = hasEnded || isLastQuestion;
        if (checkNeedsClose && !checkNullOrUndefined(rMsg)) {
            alert(rMsg);
        }

        if (checkNeedsClose) {
            $("#dwInspectionQuestions").igDialog("close");
        }
        else {
                $(".down_nav").click();

        }
        //var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
        //var InspectionListID = $("#cboxInspectionList").igCombo("value");
        //if (selectedProdDetailID && InspectionListID) {
          //  var contextParam = [];
           // contextParam["rebind"] = true;
           // contextParam["closeInspectionDialog"] = (hasEnded || isLastQuestion);
           // contextParam["hasAnsweredQuestion"] = true;
           // PageMethods.getMSInspectionListAndData(selectedProdDetailID, InspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData, contextParam);
        // }
    }
}


function onFail_setInspectionResult(value, ctx, method) {
    sendtoErrorPage("Error in InspectionsQuestions, onFail_setInspectionResult");
}