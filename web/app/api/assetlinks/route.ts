import { NextResponse } from "next/server";

export async function GET() {
  const data = [
    {
      relation: ["delegate_permission/common.handle_all_urls"],
      target: {
        namespace: "android_app",
        package_name: "app.lernarena",
        sha256_cert_fingerprints: [
          "02:5F:6A:E6:5E:3B:8C:CB:0A:79:08:BA:32:5D:28:FC:E4:DB:94:66:36:80:41:6E:5A:E2:E2:EE:4C:45:00:35",
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