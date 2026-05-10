import { NextResponse } from "next/server";

export async function GET() {
  const data = [
    {
      relation: ["delegate_permission/common.handle_all_urls"],
      target: {
        namespace: "android_app",
        package_name: "app.lernarena",
        sha256_cert_fingerprints: [
          "B5:12:92:D1:A8:25:ED:95:5A:4D:64:46:21:E7:8C:D9:8A:67:50:96:E7:85:6D:3A:A7:09:A0:6A:6E:8E:37:61"
        ]
      }
    }
  ];

  return NextResponse.json(data, {
    headers: {
      "Content-Type": "application/json"
    }
  });
}