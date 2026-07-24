import 'package:flutter/material.dart';

import '../models/high_tech_node_definition.dart';
import '../models/high_tech_tree_layout.dart';

class HighTechNode extends StatelessWidget {
  const HighTechNode({
    super.key,
    required this.definition,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final HighTechNodeDefinition definition;
  final int level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isComplete = level >= definition.maxLevel;

    return SizedBox(
      width: highTechNodeWidth,
      height: highTechNodeHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xEE17130F),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFFD978)
                    : isComplete
                    ? const Color(0xFFC89B4A)
                    : const Color(0xFF6F5832),
                width: isSelected ? 2.5 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? const Color(0x66D7A743)
                      : const Color(0x66000000),
                  blurRadius: isSelected ? 16 : 8,
                  spreadRadius: isSelected ? 1 : 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0D0B09),
                          border: Border.all(color: const Color(0xFF8B6B34)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7),
                        child: Image.asset(
                          definition.assetPath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.hub_outlined,
                              size: 34,
                              color: Color(0xFFC89B4A),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF0A0806),
                            border: Border.all(color: const Color(0xFFC89B4A)),
                          ),
                          child: Text(
                            '$level/${definition.maxLevel}',
                            style: const TextStyle(
                              color: Color(0xFFFFE5A5),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  definition.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF3E4C1),
                    fontSize: 11,
                    height: 1.05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
