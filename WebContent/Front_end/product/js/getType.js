let contextPath = $("#contextPath").val();
$.ajax({
    url: contextPath + "/ProductTypeAjax",
    type : "GET",
    dataType : "json",
    success : function(data) {
        $.each(data, function(index, value) {
            $("#ptype").append(
                `<option value="${value.pt_id}">${value.pt_platform} ${value.pt_kind}</option>`
            )
        })
    }
})

$("#search").click(function() {
    $("#searchForm").submit();
});