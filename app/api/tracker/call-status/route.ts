import { createClient } from "@/lib/supabase/server"
import { NextResponse } from "next/server"

export async function GET() {
  const supabase = await createClient()
  
  const { data, error } = await supabase
    .from("call_statuses")
    .select("*")
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  // Convert array to record format for the frontend
  const statusRecord: Record<string, string> = {}
  data?.forEach((item) => {
    statusRecord[item.lead_id] = item.status
  })
  
  return NextResponse.json({ statuses: statusRecord })
}

export async function POST(request: Request) {
  const supabase = await createClient()
  const body = await request.json()
  
  const { lead_id, status } = body
  
  if (!lead_id || !status) {
    return NextResponse.json({ error: "Missing lead_id or status" }, { status: 400 })
  }
  
  const { error } = await supabase
    .from("call_statuses")
    .upsert({
      lead_id,
      status,
      updated_at: new Date().toISOString(),
    }, {
      onConflict: "lead_id"
    })
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  return NextResponse.json({ success: true })
}
