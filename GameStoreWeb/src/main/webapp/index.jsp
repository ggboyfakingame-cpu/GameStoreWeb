<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>GameStore - Acceso al Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-light d-flex align-items-center vh-100">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card bg-secondary text-white shadow">
                <div class="card-body p-4">
                    <h3 class="text-center mb-4">🎮 GameStore Inventario</h3>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <c:if test="${not empty mensaje}">
                        <div class="alert alert-success">${mensaje}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post" class="mb-4">
                        <input type="hidden" name="accion" value="login">
                        <div class="mb-3">
                            <label>Correo electrónico</label>
                            <input type="email" name="email" class="form-control" required value="admin@gamestore.com">
                        </div>
                        <div class="mb-3">
                            <label>Contraseña</label>
                            <input type="password" name="password" class="form-control" required value="Admin123!">
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Iniciar Sesión</button>
                    </form>

                    <hr>
                    <details>
                        <summary class="text-center" style="cursor:pointer;">¿No tienes cuenta? Regístrate aquí</summary>
                        <form action="${pageContext.request.contextPath}/login" method="post" class="mt-3">
                            <input type="hidden" name="accion" value="registro">
                            <div class="mb-2">
                                <input type="text" name="nombre" class="form-control form-control-sm" placeholder="Nombre completo" required>
                            </div>
                            <div class="mb-2">
                                <input type="email" name="email" class="form-control form-control-sm" placeholder="Correo electrónico" required>
                            </div>
                            <div class="mb-2">
                                <input type="password" name="password" class="form-control form-control-sm" placeholder="Contraseña (mín. 6 caracteres)" required>
                            </div>
                            <button type="submit" class="btn btn-success btn-sm w-100">Crear Cuenta</button>
                        </form>
                    </details>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>