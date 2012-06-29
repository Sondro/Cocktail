/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktail.core.renderer;

import cocktail.core.dom.Node;
import cocktail.core.html.HTMLElement;
import cocktail.port.NativeElement;
import cocktail.core.style.CoreStyle;
import haxe.Log;
import cocktail.core.geom.GeomData;

/**
 * An Inline Box renderer is an element which participates
 * in an inline formatting context and which does not establishes
 * a formatting context.
 * 
 * It generates a line box for each line into which one of its children
 * participates
 * 
 * @author Yannick DOMINGUEZ
 */
class InlineBoxRenderer extends FlowBoxRenderer
{
	/**
	 * class constructor
	 */
	public function new(node:HTMLElement) 
	{
		super(node);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE RENDERING METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Overriden as InlineBoxRenderer doesn't render a background of his own, it is its
	 * generatd line boxes which render their own backgrounds
	 */
	override private function renderBackground(graphicContext:NativeElement):Void
	{
		
	}
	
	/**
	 * Overriden as rendering an inline box renderer consist in rendering all of the 
	 * line boxes it generated
	 */
	override private function renderChildren(graphicContext:NativeElement, forceRendering:Bool):Void
	{
		super.renderChildren(graphicContext, forceRendering);
		
		//render negative z-index LayerRenderer
		if (establishesNewStackingContext() == true)
		{
			layerRenderer.renderNegativeChildElementRenderers(graphicContext, forceRendering);
		}
		
		//render all the child line boxes which belong to the same
		//stacking context as this InlineBoxRenderer
		renderChildLineBoxes(graphicContext, forceRendering);
		
		if (establishesNewStackingContext() == true)
		{	
			layerRenderer.renderZeroAndAutoChildElementRenderers(graphicContext, forceRendering);
			layerRenderer.renderPositiveChildElementRenderers(graphicContext, forceRendering);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE RENDERING METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Actually render the child line boxes
	 */
	private function renderChildLineBoxes(graphicContext:NativeElement, forceRendering:Bool):Void
	{
		var length:Int = lineBoxes.length;
		
		for (i in 0...length)
		{
			var childLineBoxes:Array<LineBox> = getLineBoxesInLine(lineBoxes[i]);
			
			var childLength:Int = childLineBoxes.length;
			for (j in 0...childLength)
			{
				if (childLineBoxes[j].layerRenderer == layerRenderer)
				{
					childLineBoxes[j].render(graphicContext, forceRendering);
				}
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN GETTER
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Overriden as the bounds of an inline box renderer is formed
	 * by the bounds of all of the line boxes it creates during
	 * formatting
	 */
	override private function get_bounds():RectangleData
	{
		var lineBoxesBounds:Array<RectangleData> = new Array<RectangleData>();
		var length:Int = lineBoxes.length;
		for (i in 0...length)
		{
			lineBoxesBounds.push(lineBoxes[i].bounds);
		}
		
		return getChildrenBounds(lineBoxesBounds);
	}
}