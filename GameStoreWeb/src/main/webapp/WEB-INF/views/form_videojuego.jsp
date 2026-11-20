<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>${empty juego ? 'Registrar Videojuego' : 'Editar Videojuego'} - GameStore</title>
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
            </span>
            <a href="${pageContext.request.contextPath}/videojuegos" class="btn btn-outline-light btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Volver al Catálogo
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
            </a>
        </div>
    </div>
</nav>

<div class="container py-5" style="max-width: 720px;">
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-dark text-white py-3 d-flex align-items-center gap-2">
            <i class="bi ${empty juego ? 'bi-plus-circle text-success' : 'bi-pencil-square text-warning'} fs-5"></i>
            <h5 class="mb-0">${empty juego ? 'Registrar Nuevo Videojuego' : 'Editar Videojuego'}</h5>
        </div>
        <div class="card-body p-4">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-octagon-fill me-2"></i>${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/videojuegos" method="post">
                <input type="hidden" name="id_juego" value="${juego.idJuego}">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Código SKU</label>
                        <input type="text" name="codigo_sku" value="${juego.codigoSku}" class="form-control font-monospace" required placeholder="GS-PC-004">
                    </div>
                    <div class="col-md-8">
                        <label class="form-label fw-semibold">Título del Videojuego</label>
                        <input type="text" name="titulo" value="${juego.titulo}" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Plataforma</label>
                        <select name="id_plataforma" class="form-select" required>
                            <option value="1" ${juego.idPlataforma == 1 ? 'selected' : ''}>PC / Steam</option>
                            <option value="2" ${juego.idPlataforma == 2 ? 'selected' : ''}>PlayStation 5</option>
                            <option value="3" ${juego.idPlataforma == 3 ? 'selected' : ''}>Xbox Series X|S</option>
                            <option value="4" ${juego.idPlataforma == 4 ? 'selected' : ''}>Nintendo Switch</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Género</label>
                        <input type="text" name="genero" value="${juego.genero}" class="form-control" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Clasificación ESRB</label>
                        <select name="clasificacion_esrb" class="form-select">
                            <option value="E" ${juego.clasificacionEsrb == 'E' ? 'selected' : ''}>E (Todos)</option>
                            <option value="E10+" ${juego.clasificacionEsrb == 'E10+' ? 'selected' : ''}>E10+</option>
                            <option value="T" ${juego.clasificacionEsrb == 'T' ? 'selected' : ''}>T (Adolescentes)</option>
                            <option value="M" ${juego.clasificacionEsrb == 'M' ? 'selected' : ''}>M (Maduro +17)</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Precio (MXN)</label>
                        <div class="input-group">
                            <span class="input-group-text">$</span>
                            <input type="number" step="0.01" min="1" name="precio" value="${juego.precio}" class="form-control" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Stock Disponible</label>
                        <input type="number" min="0" name="stock" value="${juego.stock}" class="form-control" required>
                    </div>
                </div>

                <hr class="my-4">
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/videojuegos" class="btn btn-outline-secondary px-4">Cancelar</a>
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-save me-1"></i> Guardar Cambios
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>