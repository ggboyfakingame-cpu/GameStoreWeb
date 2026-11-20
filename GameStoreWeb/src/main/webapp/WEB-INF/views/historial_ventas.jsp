<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de Ventas - GameStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-body-tertiary">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm px-4 py-3">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/videojuegos">
            <i class="bi bi-controller text-primary fs-4"></i>
            <span>GameStore <span class="text-secondary fw-normal">| Reporte de Ventas</span></span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/videojuegos" class="btn btn-outline-light btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Volver al Inventario
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
            </a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold"><i class="bi bi-receipt me-2 text-primary"></i>Historial de Transacciones</h4>
        <div class="card border-success shadow-sm">
            <div class="card-body py-2 px-3 text-success">
                <span class="small text-uppercase fw-semibold d-block">Ingresos Totales</span>
                <span class="fs-5 fw-bold">$${ingresosTotales} MXN</span>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>ID Venta</th>
                        <th>Fecha y Hora</th>
                        <th>SKU</th>
                        <th>Videojuego</th>
                        <th>Cantidad</th>
                        <th>Total</th>
                        <th>Atendido por</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="v" items="${ventas}">
                        <tr>
                            <td class="fw-bold text-muted">#${v.idVenta}</td>
                            <td>${v.fecha}</td>
                            <td><span class="badge bg-light text-dark border font-monospace">${v.codigoSku}</span></td>
                            <td class="fw-semibold">${v.tituloJuego}</td>
                            <td>${v.cantidad} uds.</td>
                            <td class="text-success fw-bold">$${v.total} MXN</td>
                            <td><i class="bi bi-person me-1 text-muted"></i>${v.vendedor}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty ventas}">
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-cart-x fs-2 d-block mb-2"></i>
                                Aún no se han registrado ventas.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>