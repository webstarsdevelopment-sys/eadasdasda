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
  
  // First check if a settings row exists
  const { data: existing } = await supabase
    .from("settings")
    .select("id")
    .limit(1)
    .single()
  
  if (existing) {
    // Update existing
    const { error } = await supabase
      .from("settings")
      .update({
        active_sheet_id: body.active_sheet_id,
        filter_duplicates: body.filter_duplicates,
        updated_at: new Date().toISOString(),
      })
      .eq("id", existing.id)
    
    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 })
    }
  } else {
    // Insert new
    const { error } = await supabase
      .from("settings")
      .insert({
        active_sheet_id: body.active_sheet_id,
        filter_duplicates: body.filter_duplicates,
      })
    
    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 })
    }
  }
  
  return NextResponse.json({ success: true })
}
