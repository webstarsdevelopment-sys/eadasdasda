import { createClient } from "@/lib/supabase/server"
import { NextResponse } from "next/server"

export async function GET() {
  const supabase = await createClient()
  
  const { data, error } = await supabase
    .from("settings")
    .select("*")
    .limit(1)
    .single()
  
  if (error && error.code !== "PGRST116") { // PGRST116 = no rows found
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  return NextResponse.json({ 
    settings: data || { 
      active_sheet_id: null, 
      filter_duplicates: true 
    } 
  })
}

export async function POST(request: Request) {
  const supabase = await createClient()
  const body = await request.json()
  
  // Use upsert to update the single settings row (id=1)
  const { error } = await supabase
    .from("settings")
    .upsert({
      id: 1,
      active_sheet_id: body.active_sheet_id,
      filter_duplicates: body.filter_duplicates,
      updated_at: new Date().toISOString(),
    })
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  return NextResponse.json({ success: true })
}
