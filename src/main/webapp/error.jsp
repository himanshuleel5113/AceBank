<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorTitle} - AceBank</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <header class="bg-blue-900 text-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <a href="index.jsp" class="text-2xl font-bold">
                <i class="fas fa-university mr-2"></i>
                <span class="text-blue-400">Ace</span><span class="text-yellow-400">Bank</span>
            </a>
        </div>
    </header>

    <div class="max-w-2xl mx-auto mt-16 px-4">
        <div class="bg-white rounded-xl shadow-lg p-8 text-center">
            <div class="mb-6">
                <i class="fas fa-exclamation-triangle text-7xl ${errorCode == 404 ? 'text-yellow-500' : 'text-red-500'}"></i>
            </div>
            <p class="text-7xl font-bold text-gray-200 mb-4">${errorCode}</p>
            <h2 class="text-3xl font-bold text-gray-800 mb-4">${errorTitle}</h2>
            <p class="text-gray-600 mb-8">${errorMessage}</p>
            <div class="flex gap-4 justify-center">
                <a href="javascript:history.back()" class="bg-gray-600 text-white px-6 py-3 rounded-lg hover:bg-gray-700 transition">
                    <i class="fas fa-arrow-left mr-2"></i>Go Back
                </a>
                <a href="home" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition">
                    <i class="fas fa-home mr-2"></i>Dashboard
                </a>
            </div>
        </div>
    </div>
</body>
</html>