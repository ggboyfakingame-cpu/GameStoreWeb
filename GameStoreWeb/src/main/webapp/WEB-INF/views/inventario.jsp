<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo e Inventario - GameStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-body-tertiary">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm px-4 py-3">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/videojuegos">
            <i class="bi bi-controller text-primary fs-4"></i>
            <span>GameStore <span class="text-secondary fw-normal">| Inventario & Ventas</span></span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <span class="text-light small">
                <i class="bi bi-person-circle me-1"></i>
                <strong>${sessionScope.usuario.nombre}</strong>
                <span class="badge bg-primary ms-1">${sessionScope.usuario.rol}</span>
            </span>
            <a href="${pageContext.request.contextPath}/ventas" class="btn btn-outline-info btn-sm">
                <i class="bi bi-graph-up-arrow me-1"></i> Historial de Ventas
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
            </a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <c:if test="${not empty sessionScope.flashOk}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.flashOk}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="flashOk" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.flashError}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.flashError}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="flashError" scope="session"/>
    </c:if>

    <!-- Barra de Filtros y Botón Modal -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/videojuegos" method="get" class="row g-2 align-items-center">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="q" value="${param.q}" class="form-control" placeholder="Buscar título, SKU o género...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="plataforma" class="form-select">
                        <option value="">Todas las plataformas</option>
                        <option value="1" ${param.plataforma == '1' ? 'selected' : ''}>PC / Steam</option>
                        <option value="2" ${param.plataforma == '2' ? 'selected' : ''}>PlayStation 5</option>
                        <option value="3" ${param.plataforma == '3' ? 'selected' : ''}>Xbox Series X|S</option>
                        <option value="4" ${param.plataforma == '4' ? 'selected' : ''}>Nintendo Switch</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="orden" class="form-select">
                        <option value="">Orden: Más recientes</option>
                        <option value="precio_asc" ${param.orden == 'precio_asc' ? 'selected' : ''}>Precio: Menor a Mayor</option>
                        <option value="precio_desc" ${param.orden == 'precio_desc' ? 'selected' : ''}>Precio: Mayor a Menor</option>
                        <option value="stock_asc" ${param.orden == 'stock_asc' ? 'selected' : ''}>Menor Stock primero</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-dark w-100">Filtrar</button>
                    <button type="button" class="btn btn-success text-nowrap" data-bs-toggle="modal" data-bs-target="#modalNuevoJuego">
                        <i class="bi bi-plus-lg"></i> Nuevo
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Tabla de Inventario -->
    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>SKU</th>
                        <th>Videojuego</th>
                        <th>Plataforma</th>
                        <th>Género</th>
                        <th>ESRB</th>
                        <th>Precio</th>
                        <th>Stock</th>
                        <th>Venta Rápida</th>
                        <th class="text-end">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="j" items="${videojuegos}">
                        <tr>
                            <td><span class="badge bg-light text-dark border font-monospace">${j.codigoSku}</span></td>
                            <td class="fw-semibold">${j.titulo}</td>
                            <td><span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">${j.nombrePlataforma}</span></td>
                            <td class="text-muted">${j.genero}</td>
                            <td><span class="badge bg-secondary">${j.clasificacionEsrb}</span></td>
                            <td class="fw-bold text-dark">$${j.precio} <small class="text-muted fw-normal">MXN</small></td>
                            <td>
                                <span class="badge ${j.stock <= 5 ? 'bg-danger' : 'bg-success'}">
                                    ${j.stock} uds.
                                </span>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/ventas" method="post" class="d-flex gap-1" style="max-width: 155px;">
                                    <input type="hidden" name="id_juego" value="${j.idJuego}">
                                    <input type="number" name="cantidad" value="1" min="1" max="${j.stock}" class="form-control form-control-sm" required>
                                    <button type="submit" class="btn btn-sm btn-primary" ${j.stock == 0 ? 'disabled' : ''}>Vender</button>
                                </form>
                            </td>
                            <td class="text-end text-nowrap">
                                <a href="${pageContext.request.contextPath}/videojuegos?accion=editar&id=${j.idJuego}" class="btn btn-sm btn-outline-warning text-dark">
                                    <i class="bi bi-pencil"></i> Editar
                                </a>
                                <a href="${pageContext.request.contextPath}/videojuegos?accion=eliminar&id=${j.idJuego}" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Dar de baja este videojuego del catálogo?')">
                                    <i class="bi bi-trash"></i> Baja
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty videojuegos}">
                        <tr>
                            <td colspan="9" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                No se encontraron videojuegos con los filtros seleccionados.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- MODAL FLOTANTE PARA AGREGAR VIDEOJUEGO SIN SALIR DE LA PÁGINA -->
<div class="modal fade" id="modalNuevoJuego" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title d-flex align-items-center gap-2">
                    <i class="bi bi-plus-circle text-success"></i> Registrar Nuevo Videojuego
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <form action="${pageContext.request.contextPath}/videojuegos" method="post">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Código SKU</label>
                            <input type="text" name="codigo_sku" class="form-control font-monospace" required placeholder="GS-PC-004">
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Título del Videojuego</label>
                            <input type="text" name="titulo" class="form-control" required placeholder="Ej. Elden Ring">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Plataforma</label>
                            <select name="id_plataforma" class="form-select" required>
                                <option value="1">PC / Steam</option>
                                <option value="2">PlayStation 5</option>
                                <option value="3">Xbox Series X|S</option>
                                <option value="4">Nintendo Switch</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Género</label>
                            <input type="text" name="genero" class="form-control" required placeholder="RPG, Shooter, Aventura...">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Clasificación ESRB</label>
                            <select name="clasificacion_esrb" class="form-select">
                                <option value="E">E (Todos)</option>
                                <option value="E10+">E10+</option>
                                <option value="T">T (Adolescentes)</option>
                                <option value="M">M (Maduro +17)</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Precio (MXN)</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" step="0.01" min="1" name="precio" class="form-control" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Stock Inicial</label>
                            <input type="number" min="0" name="stock" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-save me-1"></i> Guardar Videojuego
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>