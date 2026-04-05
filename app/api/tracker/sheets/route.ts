import { createClient } from "@/lib/supabase/server"
import { NextResponse } from "next/server"

export async function GET() {
  const supabase = await createClient()
  
  const { data, error } = await supabase
    .from("sheets")
    .select("*")
    .order("created_at", { ascending: true })
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  return NextResponse.json({ sheets: data })
}

export async function POST(request: Request) {
  const supabase = await createClient()
  const body = await request.json()
  
  const sheetId = `sheet-${Date.now()}`
  
  const { data, error } = await supabase
    .from("sheets")
    .insert({
      id: sheetId,
      label: body.label,
      url: body.url,
    })
    .select()
    .single()
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  return NextResponse.json({ sheet: data })
}

export async function DELETE(request: Request) {
  const supabase = await createClient()
  const { searchParams } = new URL(request.url)
  const id = searchParams.get("id")
  
  if (!id) {
    return NextResponse.json({ error: "Missing sheet id" }, { status: 400 })
  }
  
  const { error } = await supabase
    .from("sheets")
    .delete()
    .eq("id", id)
  
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  
  return NextResponse.json({ success: true })
}
