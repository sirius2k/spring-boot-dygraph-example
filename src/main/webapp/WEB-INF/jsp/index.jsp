<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="ko">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Spring + dygraph demo</title>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/bootstrap-theme.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <link rel="stylesheet" href="css/dygraph.css" />
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
    <!-- Fixed navbar -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">dygraph demo</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li class="active"><span id="datetime"></span></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">조회범위 <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#" class="timeRange" data-minutes="120">최근 2시간</a></li>
                            <li><a href="#" class="timeRange" data-minutes="240">최근 4시간</a></li>
                            <li><a href="#" class="timeRange" data-minutes="360">최근 6시간</a></li>
                            <li><a href="#" class="timeRange" data-minutes="720">최근 12시간</a></li>
                            <li><a href="#" class="timeRange" data-minutes="1440">최근 1일</a></li>
                            <li><a href="#" class="timeRange" data-minutes="4320">최근 3일</a></li>
                            <li><a href="#" class="timeRange" data-minutes="10080">최근 7일</a></li>
                            <li role="separator" class="divider"></li>
                            <!--li class="dropdown-header">Nav header</li-->
                            <li><a href="#">범위 지정</a></li>
                        </ul>
                    </li>
                </ul>
            </div><!--/.nav-collapse -->
        </div>
    </nav>
    <div class="container theme-showcase" role="main">
        <div class="page-header">
            <div class="row">
                <div class="col-md-4">
                    <h1>Sum <span class="label label-default"><fmt:formatNumber value="${randomData.sum}"/></span></h1>
                </div>
                <div class="col-md-4">
                </div>
                <div class="col-md-4 text-right">
                    <h1 id="time"></h1>
                </div>
            </div>
        </div>
        <div id="graphdiv2" class="col-md-12">Graph</div>
    </div>
    <form id="dataHistoryForm" name="dataHistoryForm" action="/">
        <input type="hidden" id="timeRangeInMinutes" name="timeRangeInMinutes" value="${param.timeRangeInMinutes}"/>
    </form>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/dygraph.min.js"></script>
    <script type="text/javascript">
        var data = [
            <c:if test="${!empty randomDataHistory}">
                <c:forEach var='history' items='${randomDataHistory}' varStatus='status'>
                    [new Date("<fmt:formatDate pattern='yyyy/MM/dd HH:mm:ss' value='${history.createdDate}'/>"), ${empty history.sum ? 0 : history.sum}]<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            </c:if>
        ];

        window.onload = function() {
            <c:if test="${!empty randomDataHistory}">
            g2 = new Dygraph(
                $("#graphdiv2").get(0), data,
                {
                    rollPeriod: 1,
                    showRoller: false,
                    labels: ['Time', 'Sum']
                }
            );

            g2.resize();
            </c:if>

            $('.timeRange[data-minutes="${timeRangeInMinutes}"]').parent().addClass('font-weight-bold');
            $('.timeRange').on('click', function(event) {
               event.preventDefault();
               changeTimeRange($(event.target).data("minutes"));
            });

            rangeText = $('.timeRange[data-minutes="${timeRangeInMinutes}"]').text();

            printTime();
            setInterval(reloadPage, 3000);
        }

        function printTime() {
            var now = new Date(); // 현재시간
            var h = now.getHours();
            var m = now.getMinutes();
            var s = now.getSeconds();
            h = checkTime(h);
            m = checkTime(m);
            s = checkTime(s);

            $('#time').text(h + ":" + m + ":" + s + " (" + rangeText + ")");

            setTimeout(printTime, 1000); // setTimeout(“실행할함수”,시간) 시간은1초의 경우 1000
        }

        function checkTime(num) {
            if (num < 10) {
                num = "0" + num;
            }
            return num;
        }

        function reloadPage() {
            location.reload();
        }

        function changeTimeRange(timeRangeInMinutes) {
            $("#timeRangeInMinutes").val(timeRangeInMinutes);
            $("#dataHistoryForm").submit();
        }
    </script>
</body>
</html>