import os
import sys
import uuid

from azure.core.exceptions import HttpResponseError, ResourceNotFoundError
from azure.identity import ManagedIdentityCredential
from azure.storage.blob import BlobClient


def required(name: str) -> str:
    value = os.getenv(name)
    if not value:
        print(f"Missing required environment variable: {name}", file=sys.stderr)
        raise SystemExit(2)
    return value


client_id = required("AZURE_CLIENT_ID")
account = required("STORAGE_ACCOUNT_NAME")
container = required("TEST_CONTAINER")
blob_name = required("TEST_BLOB")

credential = ManagedIdentityCredential(client_id=client_id)
account_url = f"https://{account}.blob.core.windows.net"

failed = False

read_blob = BlobClient(
    account_url=account_url,
    container_name=container,
    blob_name=blob_name,
    credential=credential,
)

try:
    data = read_blob.download_blob(max_concurrency=1).readall()
    print(f"PASS  ZT-NEG-006 Managed identity read succeeded ({len(data)} bytes)")
except ResourceNotFoundError:
    print("FAIL  ZT-NEG-006 Seed test blob was not found")
    failed = True
except HttpResponseError as exc:
    print(f"FAIL  ZT-NEG-006 Managed identity read failed: HTTP {exc.status_code}")
    failed = True

probe_name = f"_zero-trust-negative-test/{uuid.uuid4()}.txt"
probe = BlobClient(
    account_url=account_url,
    container_name=container,
    blob_name=probe_name,
    credential=credential,
)

try:
    probe.upload_blob(b"zero-trust-negative-security-test", overwrite=False)
    print("FAIL  ZT-NEG-007 Unauthorized write unexpectedly succeeded")
    failed = True

    try:
        probe.delete_blob()
        print("INFO  Unexpectedly-created test object was deleted")
    except HttpResponseError:
        print(f"INFO  Cleanup denied; remove test object manually: {probe_name}")

except HttpResponseError as exc:
    if exc.status_code in (401, 403):
        print(f"PASS  ZT-NEG-007 Unauthorized write was denied (HTTP {exc.status_code})")
    else:
        print(f"FAIL  ZT-NEG-007 Write failed for an unexpected reason: HTTP {exc.status_code}")
        failed = True

sys.exit(1 if failed else 0)
