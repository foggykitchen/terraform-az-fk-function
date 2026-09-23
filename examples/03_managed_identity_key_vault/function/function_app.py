import os

import azure.functions as func

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


@app.route(route="secret-status")
def secret_status(req: func.HttpRequest) -> func.HttpResponse:
    configured = bool(os.getenv("EXAMPLE_API_KEY"))
    return func.HttpResponse(f"Key Vault reference resolved: {configured}")
