import { createClient } from "@/lib/supabase/server"
import { NextResponse } from "next/server"

export async function GET() {
  const supabase = await createClient()
  
  const { data, error } = await supabase
    .from("notes")
    .select("*")
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  // Convert array to record format for the frontend
  const notesRecord: Record<string, string> = {}
  data?.forEach((item) => {
    notesRecord[item.lead_id] = item.note
  })
  
  return NextResponse.json({ notes: notesRecord })
}

export async function POST(request: Request) {
  const supabase = await createClient()
  const body = await request.json()
  
  const { lead_id, note } = body
  
  if (!lead_id) {
    return NextResponse.json({ error: "Missing lead_id" }, { status: 400 })
  }
  
  const { error } = await supabase
    .from("notes")
    .upsert({
      lead_id,
      note: note || "",
      updated_at: new Date().toISOString(),
    }, {
      onConflict: "lead_id"
    })
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  return NextResponse.json({ success: true })
}
